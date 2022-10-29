import 'package:flutter/material.dart';

class MyBrick extends StatelessWidget {

  //x and y coordinate initializations
  final x;
  final y;
  final brickWidth; // out of 2
  final thisIsEnemy;

  //constructors for mybrick
  MyBrick({this.x, this.y, this.brickWidth, this.thisIsEnemy});


  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment((2 * x + brickWidth) / (2 - brickWidth), y),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
          color: thisIsEnemy ? Colors.deepPurple[300] : Colors.pink[300],
          height: 20,
          width: MediaQuery.of(context).size.width * brickWidth / 2,
          ),
        ),
    );
  }
}
