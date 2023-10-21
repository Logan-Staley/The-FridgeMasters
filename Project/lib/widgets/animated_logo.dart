import 'package:flutter/material.dart';

class AnimatedLogo extends StatefulWidget {
  final VoidCallback? onAnimationCompleted;

  AnimatedLogo({this.onAnimationCompleted});

  @override
  _AnimatedLogoState createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<AnimatedLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _animation = Tween<double>(begin: -0.52, end: 0.8).animate(_controller)
      ..addStatusListener((status) {
        if (!_isDisposed && status == AnimationStatus.completed) {
          if (widget.onAnimationCompleted != null) {
            widget.onAnimationCompleted!();
          }
        }
      });

    _startMeteorAnimation();
  }

  void _startMeteorAnimation() {
    if (!_isDisposed) {
      _controller.reset();
      _controller.forward().whenComplete(() {
        // Trigger the onAnimationCompleted callback if provided
        if (widget.onAnimationCompleted != null) {
          widget.onAnimationCompleted!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final meteorPosition = _animation.value;
            final meteorScale = (_animation.value + 1).clamp(0.0, 1.0);

            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: constraints.maxWidth * meteorPosition,
                  child: Transform.scale(
                    scale: meteorScale,
                    child: Image.asset(
                      'images/fridgemasters-logo.png',
                      width: 450,
                    ),
                  ),
                ),
                ShimmeringCircle(
                  animation: _controller,
                  constraints: constraints,
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}

class ShimmeringCircle extends StatelessWidget {
  final Animation<double> animation;
  final BoxConstraints constraints;

  ShimmeringCircle({required this.animation, required this.constraints});

  @override
  Widget build(BuildContext context) {
    final shimmerPosition = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1),
        weight: 0.4,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0),
        weight: 0.1,
      ),
    ]).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOutQuart,
    ));

    return AnimatedBuilder(
      animation: shimmerPosition,
      builder: (context, child) {
        final position = shimmerPosition.value;

        return Opacity(
          opacity: position,
          child: Container(
            width: constraints.maxWidth * position * 2.0,
            height: constraints.maxHeight * position * 2.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(231, 158, 158, 158),
            ),
          ),
        );
      },
    );
  }
}