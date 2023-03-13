
import 'package:flutter/material.dart';

class BlackAndWhiteImage extends StatelessWidget {
  final String imageUrl;
  final double width;

  const BlackAndWhiteImage({Key? key, required this.imageUrl,required this.width,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0.2126, 0.7152, 0.0722, 0, 0,
        0,      0,      0,      1, 0,
      ]),
      child: Image.asset(imageUrl,width: width),
    );
  }
}
