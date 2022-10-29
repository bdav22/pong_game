import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {

  //x and y coords
  final x;
  final y;
  final bool gameHasStarted;

  //constructor
  MyBall({this.x,this.y, required this.gameHasStarted});

  @override
  Widget build(BuildContext context) {
    return gameHasStarted
        ? Container(
            alignment: Alignment(x,y),
            child: Container(
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              width: 14,
              height: 14,
      ),
    )
        : Container(
      alignment: Alignment(x,y),
      child: AvatarGlow(
        endRadius: 60.0,
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.white),
            width: 30,
            height: 30,
            ),
          radius: 7.0,
          ),
        )
      );

  }





}
