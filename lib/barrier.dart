import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierWidth;
  final barrierHeight;
  final barrierX;
  final bool isBottom;

  MyBarrier(
      {this.barrierHeight,
      this.barrierWidth,
      required this.isBottom,
      this.barrierX});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isBottom ? 1.1 : -1.1),
      child: Container(
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
        decoration: BoxDecoration(
          color: Colors.greenAccent,
          border: Border.all(
              color: Colors.black87,
              width: 5.0,
              strokeAlign: BorderSide.strokeAlignInside),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
