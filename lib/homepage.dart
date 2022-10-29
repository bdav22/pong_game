import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/ball.dart';
import 'package:pong/brick.dart';
import 'package:pong/coverscreen.dart';
import 'package:pong/scorescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}


//contains the possible directions the ball can travel
enum direction { UP, DOWN, LEFT, RIGHT }


class _HomePageState extends State<HomePage> {

  //player variables (bottom brick)
  double playerX = 0;
  double brickWidth = 0.4; // out of 2
  int playerScore = 0;

  //enemy variables (top brick)
  double enemyX = -0.2;
  int enemyScore = 0;


  //ball variables
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;



  //bool to keep track if game has started
  bool gameHasStarted = false;

  //function to start the game
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 1), (timer) {

      //update direction
      updateDirection();

      //move the ball
      moveBall();

      //move enemy
      moveEnemy();

      //check if player is dead
      if(isPlayerDead()) {
        enemyScore++;
        timer.cancel();
        _showDialog(false);
      }

      if (isEnemyDead()) {
        playerScore++;
        timer.cancel();
        _showDialog(true);
      }

    });
  }

  void moveEnemy(){
    setState(() {
      enemyX = ballX;
    });
  }


  //testing AI vs AI method
  void moveAiPlayer() {
    setState(() {
      playerX = ballX;
    });
  }


  //prompts the user to play again
  void _showDialog(bool enemyDied) {
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context) {
           return AlertDialog(
             backgroundColor: Colors.deepPurple,
             title: Center(
               child: Text(
                 enemyDied ? "Pink Win" : "Purple Win",
                 style: TextStyle(color: Colors.white),
               ),
             ),
             actions: [
               GestureDetector(
                 onTap: resetGame,
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(5),
                   child: Container(
                     padding: EdgeInsets.all(7),
                     color: enemyDied
                         ? Colors.pink[100]
                         : Colors.pink[100],
                     child: Text(
                       'Play Again',
                       style: TextStyle(
                           color: enemyDied
                               ? Colors.pink[800]
                               : Colors.deepPurple[800]
                     ),
                   ),
                 ),
               )
               )
             ],
           );

     });

  }


  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      playerX = -0.2;
      enemyX = -0.2;
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }

    return false;
  }

  bool isEnemyDead() {
    if (ballY <= -1) {
      return true;
    }

    return false;
  }


  //updates the current direction of the ball
void updateDirection() {
    setState(() {

      // update vertical direction
      if (ballY >= 0.9 && playerX + brickWidth >= ballX && playerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }

      // update horizontal direction - make 1 and -1 the virtual boundaries. If the ball hits it will change direction
      if(ballX >= 1) {
        ballXDirection = direction.LEFT;


      } else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }


    });
}

void moveBall() {
    setState(() {


      // vertical movement
      if(ballYDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballYDirection == direction.UP) {
        ballY -= 0.01;
      }

      // horizontal movement
      if(ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }

    });



}

//method to move left. updates user brick to the left of the current pos
void moveLeft() {
    setState(() {
      if (!(playerX - 0.1 <= -1)) {
        playerX -= 0.1;
      }

    });


}

//method to move right. updates user brick to the right of the current pos
void moveRight() {
    setState(() {
      if (!(playerX + brickWidth >= 1)) {
        playerX += 0.1;
      }

    });

}



  @override
  Widget build(BuildContext context) {

    //reads in users keyboard input
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        //user presses left arrow -> move left
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();

        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.grey[800],
          body: Center(
            child: Stack(
              children: [

                //the cover screen (tap to play)
                CoverScreen(
                  gameHasStarted: gameHasStarted,
                ),


                ScoreScreen(
                  gameHasStarted: gameHasStarted,
                  enemyScore: enemyScore,
                  playerScore: playerScore,
                ),

                //top brick (enemy brick)
                MyBrick(
                  x: enemyX,
                  y: -0.9,
                  brickWidth: brickWidth,
                  thisIsEnemy: true,
                ),




                //bottom brick (player)
                MyBrick(
                    x: playerX,
                    y: 0.9,
                    brickWidth: brickWidth,
                    thisIsEnemy: false,
                ),


                //ball
                MyBall(
                  x: ballX,
                  y: ballY,
                  gameHasStarted: gameHasStarted,

                ),




              ],
            ),
          ),
        ),
      ),
    );
  }

}