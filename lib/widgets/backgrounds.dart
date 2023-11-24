import 'dart:ui';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String type;

  const Background({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 'Background1':
        return Background1();
      case 'Background2':
        return Background2();
      case 'Background3':
        return Background3();
      case 'Background4':
        return Background4();
      default:
        return Background1(); // Fallback to Background1 if type is not recognized
    }
  }
}

class Background1 extends StatelessWidget {
  const Background1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your existing code for Background1
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/test-food-image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }
}

class Background2 extends StatelessWidget {
  const Background2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Background2 with no transparency
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bell-notifications.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class Background3 extends StatelessWidget {
  const Background3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your code for Background3
    // ...
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/test-food-image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    ); // Replace with your implementation
  }
}

class Background4 extends StatelessWidget {
  const Background4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your code for Background4
    // ...
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/test-food-image.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    ); // Replace with your implementation
  }
}
