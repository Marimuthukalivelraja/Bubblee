import 'package:flutter/material.dart';

class ball extends StatelessWidget {
  final double ballX;
  final double ballY;
  ball({required this.ballX, required this.ballY});
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        width: 30,
        height: 10,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
            color: Colors.brown,
            boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
        ),
      ),
    );
  }
}