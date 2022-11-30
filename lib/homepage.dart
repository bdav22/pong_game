

//import files
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pong/ball.dart';
import 'package:pong/paddle.dart';
import 'package:pong/coverscreen.dart';
import 'package:pong/scorescreen.dart';


//constructor
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);


  @override
  _HomePageState createState() => _HomePageState();
}


//contains the possible directions the ball can travel
enum direction { UP, DOWN, LEFT, RIGHT }

//homepage class
class _HomePageState extends State<HomePage> {

  //player variables (bottom brick)
  double userX = 0;
  double paddleWidth = 0.4; // out of 2
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
      updateBall();

      //move the ball
      moveBall();

      //move enemy
      moveEnemy();

      //check if player is dead
      if(isUserDead()) {
        enemyScore++;
        timer.cancel();
        playAgainPrompt(false);
      }

      //
      if (isEnemyDead()) {
        playerScore++;
        timer.cancel();
        playAgainPrompt(true);
      }

    });
  }

  //keeps enemy position in line with ball
  void moveEnemy(){
    setState(() {
      enemyX = ballX;
    });
  }


  //testing AI vs AI method
  void moveAiPlayer() {
    setState(() {
      userX = ballX;
    });
  }


  //prompts the user to play again
  void playAgainPrompt(bool enemyDied) {
     showDialog(
         context: context,
         barrierDismissible: false,
         builder: (BuildContext context) {
           return AlertDialog(
             backgroundColor: Colors.deepOrange[800],
             title: Center(
               child: Text(
                 enemyDied ? "Blue Win" : "Orange Wins!",
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
                         ? Colors.blue[100]
                         : Colors.blue[100],
                     child: Text(
                       'Play Again?',
                       style: TextStyle(
                           color: enemyDied
                               ? Colors.deepOrangeAccent[800]
                               : Colors.deepOrange[800]
                     ),
                   ),
                 ),
               )
               )
             ],
           );

     });

  }

//function to reset the game
  void resetGame() {
    Navigator.pop(context);
    setState(() {

      //reset game started bool to false and reset ball pos
      gameHasStarted = false;
      ballX = 0;
      ballY = 0;
      userX = -0.2;
      enemyX = -0.2;
    });
  }


  //function to check if player is dead
  bool isUserDead() {
    //if the y pos of user is out of bounds
    if (ballY >= 1) {
      return true;
    }

    return false;
  }


  //function to check if enemy is dead
  bool isEnemyDead() {
    //if the y pos of enemy is out of bounds
    if (ballY <= -1) {
      return true;
    }

    return false;
  }


  //updates the current direction of the ball
void updateBall() {
    setState(() {

      // update vertical direction
      if (ballY >= 0.9 && userX + paddleWidth >= ballX && userX <= ballX) {
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

//function to move the ball
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
      if (!(userX - 0.1 <= -1)) {
        userX -= 0.1;
      }

    });


}

//method to move right. updates user brick to the right of the current pos
void moveRight() {
    setState(() {
      if (!(userX + paddleWidth >= 1)) {
        userX += 0.1;
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

      //when the user taps the screen start the game
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

                //top paddle (enemy)
                Paddle(
                  x: enemyX,
                  y: -0.9,
                  paddleWidth: paddleWidth,
                  thisIsEnemy: true,
                ),




                //bottom paddle (player)
                Paddle(
                    x: userX,
                    y: 0.9,
                    paddleWidth: paddleWidth,
                    thisIsEnemy: false
                  ,
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