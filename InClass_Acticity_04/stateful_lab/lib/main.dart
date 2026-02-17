import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stateful Counter Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;
  final List<int> _history = [0];
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateCounter(int newValue) {
    if (newValue < 0) {
      newValue = 0;
    }
    if (newValue > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Limit Reached!')),
      );
      return;
    }

    setState(() {
      _counter = newValue;
      _history.add(_counter);
    });
  }

  void _increment() {
    _updateCounter(_counter + 1);
  }

  void _decrement() {
    _updateCounter(_counter - 1);
  }

  void _reset() {
    _updateCounter(0);
  }

  void _setValue() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final value = int.tryParse(text);
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    _updateCounter(value);
    _controller.clear();
  }

  void _undo() {
    if (_history.length <= 1) return;

    setState(() {
      _history.removeLast();
      _counter = _history.last;
    });
  }

  Color _getColor() {
    if (_counter == 0) return Colors.red;
    if (_counter > 50) return Colors.green;
    return Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interactive Counter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_counter',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: _getColor(),
                ),
              ),
            ),
            const SizedBox(height: 40),

            Slider(
              min: 0,
              max: 100,
              value: _counter.toDouble(),
              divisions: 100,
              label: '$_counter',
              onChanged: (value) {
                _updateCounter(value.toInt());
              },
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _decrement,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('-1'),
                ),
                ElevatedButton(
                  onPressed: _increment,
                  child: const Text('+1'),
                ),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
                IconButton(
                  onPressed: _undo,
                  icon: const Icon(Icons.undo),
                  tooltip: 'Undo',
                ),
              ],
            ),
            const SizedBox(height: 40),

            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter custom value (0-100)',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _setValue(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _setValue,
              child: const Text('Set Value'),
            ),
          ],
        ),
      ),
    );
  }
}