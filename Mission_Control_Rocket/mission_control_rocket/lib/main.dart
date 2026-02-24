import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rocket Launch Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CounterWidget(),
    );
  }
}

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});



  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  // set counter value
  int _counter = 0;

  Color _getFuelColor() {
    if (_counter == 0) return Colors.red;
    if (_counter <= 50) return Colors.yellow;
    return Colors.green;
  }

  String _getDisplayText() {
    if (_counter == 100) return 'LIFTOFF';
    return '$_counter';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rocket Launch Controller'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              color: _getFuelColor(),
              child: Text(
                _getDisplayText(),
                style: const TextStyle(fontSize: 50.0),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _counter = value.toInt();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: (){
                  setState(() {
                    if (_counter < 100) _counter++;
                  });
                },child: const Text('Ingite')),
                const SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                  setState(() {
                    if (_counter > 0) _counter--;
                  });
                }, child: const Text('Decrement')),
                SizedBox(width: 20,),
                ElevatedButton(onPressed: (){
                  setState(() {
                    _counter = 0;
                  });
                }, child: const Text('Reset'))
            ],
          )
        ],
      ),
    );
  }
}