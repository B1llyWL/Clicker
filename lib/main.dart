import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clicker App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ImageSwitcher(),
    );
  }
}

class ImageSwitcher extends StatefulWidget {
  const ImageSwitcher({super.key});

  @override
  ImageSwitcherState createState() => ImageSwitcherState();
}

class ImageSwitcherState extends State<ImageSwitcher> {
  final List<String> sounds = [
    'sound1.mp3',
    'sound2.mp3',
    'sound3.mp3',
  ];

  String currentImage = 'assets/image1.png';
  final AudioPlayer audioPlayer = AudioPlayer();
  int clickCount = 0;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadClickCount();
  }

  Future<void> _loadClickCount() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      clickCount = _prefs.getInt('clickCount') ?? 0;
    });
  }

  Future<void> _saveClickCount() async {
    await _prefs.setInt('clickCount', clickCount);
  }

  void _onImageTap() {
    if (currentImage == 'assets/image1.png') {
      setState(() {
        currentImage = 'assets/image2.jpg';
      });
    } else {
      setState(() {
        clickCount++;
        _saveClickCount(); // Сохраняем после каждого клика
      });
      _playRandomSound();
    }
  }

  Future<void> _playRandomSound() async {
    final randomIndex = Random().nextInt(sounds.length);
    try {
      await audioPlayer.play(AssetSource(sounds[randomIndex]));
    } catch (e) {
      // Логируем ошибку через debugPrint вместо print
      debugPrint("Error playing sound: $e");
    }
  }

  // Метод для сброса счетчика (опционально)
  void _resetCounter() async {
    setState(() {
      clickCount = 0;
    });
    await _prefs.setInt('clickCount', 0);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clicker App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCounter,
            tooltip: 'Сбросить счетчик',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _onImageTap,
              child: Image.asset(
                currentImage,
                width: currentImage == 'assets/image2.jpg' ? 450 : null,
                height: currentImage == 'assets/image2.jpg' ? 450 : null,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Количество кликов',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$clickCount',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _playRandomSound();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.green,
              ),
              child: const Text(
                'Тест звука',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _resetCounter,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.red,
              ),
              child: const Text(
                'Сбросить счетчик',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}