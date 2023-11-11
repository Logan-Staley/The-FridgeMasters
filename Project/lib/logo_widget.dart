import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LogoWidget({
    Key? key,
    this.width, // Optional parameter to specify width
    this.height, // Optional parameter to specify height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/LogoFM.svg', // Path to your logo file
      width: width,
      height: height,
    );
  }
}
