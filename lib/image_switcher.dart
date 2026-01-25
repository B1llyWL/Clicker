import 'package:flutter/material.dart';

class Clicker extends StatefulWidget {
  const Clicker({super.key}); // Использован супер-параметр

  @override
  ClickerState createState() => ClickerState(); // Имя класса состояния остается прежним
}

class ClickerState extends State<Clicker> {
  int _currentIndex = 0;

  final List<String> _images = [
    'assets/image1.png',
    'assets/image2.jpg',
  ];

  void _nextImage() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _images.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _nextImage,
      child: Image.asset(
        _images[_currentIndex],
        fit: BoxFit.cover,
      ),
    );
  }
}
