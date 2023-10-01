import 'package:flutter/material.dart';

class Bird extends StatelessWidget {
  final birdY;
  final double birdWidth;
  final double birdHeight;

  Bird({this.birdY, required this.birdHeight, required this.birdWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'lib/images/flappybird1.png',
        height: MediaQuery.of(context).size.height * birdHeight / 1.3,
        width: MediaQuery.of(context).size.width * 3 / 4 * birdWidth / 0.5,
        fit: BoxFit.contain,
      ),
    );
  }
}
