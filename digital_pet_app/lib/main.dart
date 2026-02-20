import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MaterialApp(
    home: DigitalPetApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  State<DigitalPetApp> createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 80;

  late Timer _hungerTimer;
  Timer? _winCheckTimer;
  DateTime? _happyStartTime;
  bool _gameActive = true;

  @override
  void initState() {
    super.initState();
    _startHungerTimer();
    _startWinCheckTimer();
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(
      const Duration(seconds: 30),
      (timer) {
        if (!_gameActive) return;
        setState(() {
          hungerLevel += 5;
          hungerLevel = hungerLevel.clamp(0, 100);
          energyLevel -= 3;
          energyLevel = energyLevel.clamp(0, 100);

          if (hungerLevel >= 80) {
            happinessLevel -= 10;
          }
          happinessLevel = happinessLevel.clamp(0, 100);
        });
        _checkLossCondition();
      },
    );
  }

  void _startWinCheckTimer() {
    _winCheckTimer = Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        if (!_gameActive) return;
        _checkWinCondition();
        _checkLossCondition();
      },
    );
  }

  void _checkWinCondition() {
    if (happinessLevel > 80) {
      _happyStartTime ??= DateTime.now();
      final duration = DateTime.now().difference(_happyStartTime!);
      if (duration >= const Duration(minutes: 3)) {
        _gameActive = false;
        _hungerTimer.cancel();
        _winCheckTimer?.cancel();
        _showWinDialog();
      }
    } else {
      _happyStartTime = null;
    }
  }

  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10 && _gameActive) {
      _gameActive = false;
      _hungerTimer.cancel();
      _winCheckTimer?.cancel();
      _showGameOverDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('You Win! 🎉'),
        content: const Text('Your pet has been super happy for 3 minutes!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over 😢'),
        content: const Text('Your pet is too hungry and too sad...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGame();
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      petName = "Your Pet";
      happinessLevel = 50;
      hungerLevel = 50;
      energyLevel = 80;
      _happyStartTime = null;
      _gameActive = true;
    });
    _startHungerTimer();
    _startWinCheckTimer();
  }

  void _playWithPet() {
    if (!_gameActive) return;
    setState(() {
      happinessLevel += 15;
      hungerLevel += 5;
      energyLevel -= 20;
      happinessLevel = happinessLevel.clamp(0, 100);
      hungerLevel = hungerLevel.clamp(0, 100);
      energyLevel = energyLevel.clamp(0, 100);
    });
  }

  void _feedPet() {
    if (!_gameActive) return;
    setState(() {
      hungerLevel -= 15;
      happinessLevel += 15;
      energyLevel += 10;
      hungerLevel = hungerLevel.clamp(0, 100);
      happinessLevel = happinessLevel.clamp(0, 100);
      energyLevel = energyLevel.clamp(0, 100);
    });
  }

  Color _moodColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel > 30) return Colors.yellow;
    return Colors.red;
  }

  String _getMoodStatus() {
    if (happinessLevel > 70) return 'Happy 😺';
    if (happinessLevel > 30) return 'Neutral 😐';
    return 'Sad 😿';
  }

  String _getEnergyStatus() {
    if (energyLevel > 70) return 'Energized ⚡';
    if (energyLevel > 30) return 'Tired 😴';
    return 'Exhausted 💤';
  }

  void _changePetName() {
    final controller = TextEditingController(text: petName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Pet Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter new name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              setState(() {
                final newName = controller.text.trim();
                petName = newName.isNotEmpty ? newName : 'Your Pet';
              });
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _hungerTimer.cancel();
    _winCheckTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodColor = _moodColor();

    return Scaffold(
      appBar: AppBar(title: const Text('Digital Pet'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorFiltered(
                colorFilter: ColorFilter.mode(moodColor, BlendMode.modulate),
                child: Image.asset(
                  'assets/pet_image.webp',
                  width: 180,
                  height: 180,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.pets, size: 120),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(petName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Text(_getMoodStatus(), style: TextStyle(fontSize: 22, color: moodColor)),
                ],
              ),

              const SizedBox(height: 20),

              Text('Happiness: $happinessLevel%', style: TextStyle(fontSize: 18, color: moodColor)),
              Text('Hunger: $hungerLevel%', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    Text(
                      'Energy: $energyLevel% ${_getEnergyStatus()}',
                      style: TextStyle(fontSize: 18, color: energyLevel > 50 ? Colors.blue : Colors.orange),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: energyLevel / 100,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        energyLevel > 70
                            ? Colors.green
                            : energyLevel > 30
                                ? Colors.orange
                                : Colors.red,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              ElevatedButton.icon(
                onPressed: _playWithPet,
                icon: const Icon(Icons.favorite),
                label: const Text('Play with Pet'),
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _feedPet,
                icon: const Icon(Icons.restaurant),
                label: const Text('Feed Pet'),
              ),
              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _changePetName,
                icon: const Icon(Icons.edit),
                label: const Text('Change Name'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}