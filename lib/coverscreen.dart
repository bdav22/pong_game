import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {

  final bool gameHasStarted;

  CoverScreen({required this.gameHasStarted});


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0,-.2),
      child: Text(
        gameHasStarted ? ' ' :
        'Tap to play', style: TextStyle(color: Colors.white),),
    );
  }
}
