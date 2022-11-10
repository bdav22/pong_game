import 'package:flutter/material.dart';

class Paddle extends StatelessWidget {

  //x and y coordinate initializations
  final x;
  final y;
  final paddleWidth; // out of 2
  final thisIsEnemy;

  //constructors for mybrick
  Paddle({this.x, this.y, this.paddleWidth, this.thisIsEnemy});


  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2 * x + paddleWidth) / (2 - paddleWidth), y),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10), //give it ovular shape
          child: Container(
          color: thisIsEnemy ? Colors.deepOrange : Colors.blue[300],
          height: 20,
          width: MediaQuery.of(context).size.width * paddleWidth
              / 2,
          ),
        ),
    );
  }
}
