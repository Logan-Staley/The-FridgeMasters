import 'package:flutter/material.dart';
import 'logo_widget.dart';

class AnimatedLogo extends StatefulWidget {
  final VoidCallback? onAnimationCompleted;
  final double width;

  AnimatedLogo({this.onAnimationCompleted, required this.width});

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  //late Animation<double> _animation;
  //bool _isDisposed = false;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

   
_opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller)
..addStatusListener((status) {if(status == AnimationStatus.completed)
{widget.onAnimationCompleted?.call();
}

});
 
    _controller.forward();
    }
  

  //@override
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Center(
        child: LogoWidget(width: widget.width),
      ),
    );
  }

  @override
  void dispose() {
    //_isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}

