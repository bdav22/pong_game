import 'package:flutter/material.dart';


class CoverScreen extends StatelessWidget {


  final bool gameHasStarted;

  CoverScreen({required this.gameHasStarted});



  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0,-.2),
      child: Text(
        gameHasStarted ? ' ' :    //if game has not started show the tap to play
        'Tap to play', style: TextStyle(color: Colors.white),),
    );
  }
}
