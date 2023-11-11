import 'dart:ui';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String type;

  const Background({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'Background1':
        return const Background1();
      case 'Background2':
        return const Background2();
      case 'Background3':
        return const Background3();
      case 'Background4':
        return const Background4();
      default:
        return const Background1(); // Fallback to Background1 if type is not recognized
    }
  }
}

class Background1 extends StatelessWidget {
  const Background1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBackgroundWithOverlay(Colors.white);
  }
}

class Background2 extends StatelessWidget {
  const Background2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBackgroundWithOverlay(Colors.grey[100]!);
  }
}

class Background3 extends StatelessWidget {
  const Background3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBackgroundWithOverlay(Colors.grey[300]!);
  }
}

class Background4 extends StatelessWidget {
  const Background4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBackgroundWithOverlay(Colors.blueGrey[100]!);
  }
}

Widget _buildBackgroundWithOverlay(Color backgroundColor) {
  return Container(
    color: backgroundColor,
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: Colors.black.withOpacity(0.3), // Semi-transparent black overlay
      ),
    ),
  );
}
