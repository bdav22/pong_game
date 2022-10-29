import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatelessWidget {


  final bool gameHasStarted;
  final enemyScore;
  final playerScore;

  ScoreScreen({required this.gameHasStarted, this.enemyScore, this.playerScore});





  @override
  Widget build(BuildContext context) {


    //if the game has started dont display the score
    return gameHasStarted ? Stack(
      children: [

      Container(
        alignment: Alignment(0,0),
        child: Container(
          height: 1,
          width: MediaQuery.of(context).size.width / 4,
          color: Colors.grey[800],
        ),
      ),


      Container(
        alignment: Alignment(0,-0.3),
        child: Text(
          enemyScore.toString(),
          style: TextStyle(color: Colors.grey[700], fontSize: 75),
        ),
      ),



      Container(
        alignment: Alignment(0,0.3),
        child: Text(
          playerScore.toString(),
          style: TextStyle(color: Colors.grey[800], fontSize: 75),
        ),
      ),
    ],

    ) : Container();// else display an empty container
  }
}
