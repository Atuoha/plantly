import 'package:flutter/material.dart';
import '../../constants/color.dart';

class BackgroundContainer extends StatelessWidget {
  const BackgroundContainer({
    Key? key,
    required this.child,
    required this.begin,
    required this.stops,
  }) : super(key: key);
  final Widget child;
  final AlignmentGeometry begin;
  final List<double> stops;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: const [
            whiteColor,
            bgColor,
          ],
          begin: begin,
          stops: stops,
        ),
      ),
      child: child,
    );
  }
}
