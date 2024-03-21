import 'dart:async';
import 'package:bubblee/ball.dart';
import 'package:bubblee/button.dart';
import 'package:bubblee/fire.dart';
import 'package:bubblee/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction{LEFT,RIGHT}

class _HomePageState extends State<HomePage> {

  //players
  static double playerX=0;
  //fires and missile variables
  double fireX=playerX;
  double fheight=10;
  bool midShot = false;

  //ball variables
  double ballX =0.5;
  double ballY=0;
  var ballDirection=direction.LEFT;

  //startGame
  void startGame(){
  double time=0;
  double height=0;

  // //sets the direction of the moving ball
   Timer.periodic(Duration(milliseconds: 10), (timer) {

  //creating the parabola
   height= -5 * time * time + 70 * time;


  if(height <0){
    time=0;
  }
  setState(() {
   ballY = heightToPosition(height);
  });
   

  if (ballX-0.005 < -1){
     ballDirection=direction.RIGHT;
   }else if(ballX+0.005 > 1){
    ballDirection=direction.LEFT;
   }

    if(ballDirection == direction.LEFT){
        setState(() {
      ballX -=0.005;
     });
    }
    else if(ballDirection == direction.RIGHT){
        setState(() {
      ballX +=0.005;
     });
    }


    if(playerDies()){
      timer.cancel();
      _showDialog();
      
    }

     time+=0.1;
     });
  }


  void _showDialog(){
    showDialog(context: context,
     builder: (BuildContext context){
      return AlertDialog(
        backgroundColor: Colors.grey[700],
        title: Text("Game Over",style:TextStyle(color: Colors.white)),
      );
     }
     );
  }

 

  //move left
  void moveLeft(){
    setState(() {
     if( playerX -0.1 < -1){
      //nothing to do
     }
     else{
       playerX -=0.1;
     }
      if(!midShot)
      {
         fireX=playerX;
      }
    });
  }

  //move right
  void moveRight(){
    setState(() {
      if(playerX + 0.1 > 1){
        //nothing to do
      }
      else{
        playerX +=0.1;
      }
       if(!midShot)
      {
         fireX=playerX;
      }
    });
  }

  //fire
  void fire(){
  if(midShot == false){
      Timer.periodic(Duration(milliseconds: 20), (timer) {

        //shots fired
        midShot =true;

      //missile grows till it hit the top of the screen
       setState(() {
        fheight +=10;
      });  

    //stop when it reaches the top
    if(fheight > MediaQuery.of(context).size.height * 3/4)
    {
      resetFire();
      timer.cancel();
    }

      //check if it hits 
      if(ballY >heightToPosition(fheight) && (ballX-fireX).abs() < 0.03){
       resetFire();
      ballX=5;
      timer.cancel();
      }
     });
  }
  }


  //reset
  void resetFire(){
    fireX=playerX;
    fheight=10;
    midShot=false;
  }

  //heighttoPosition
  double heightToPosition(double height){
    double totalheight= MediaQuery.of(context).size.height * 3/4;
    double position= 1-2*height/totalheight;
    return position;
  }

  //playerDies
  bool playerDies(){
     if((ballX-playerX).abs() < 0.05 && ballY >0.95){
      return true;
     }
     else{
      return false;
     }
  }


  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event){
        if(event.isKeyPressed(LogicalKeyboardKey.arrowLeft)){
          moveLeft();
        }
        else if(event.isKeyPressed(LogicalKeyboardKey.arrowRight)){
          moveRight();
        }
        if(event.isKeyPressed(LogicalKeyboardKey.arrowUp)){
          fire();
        }
        if(event.isKeyPressed(LogicalKeyboardKey.space)){
          startGame();
        }
      },
      child: Column(
        children: [
          Expanded(
            flex:3,
            child: Container(
            color: Colors.pink[100],
            child: Center(
              child: Stack(
                children: [
                    ball(ballX: ballX, ballY: ballY),
                    MyFire(height: fheight,fireX: playerX,),
                    MyPlayer(
                    playerX: playerX,
                   ),
                ],
              ),
            ),
          )),
    
          Expanded(child: Container(
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MyButton(icon: Icons.play_arrow,function:startGame,),
              MyButton(icon: Icons.arrow_back,function:moveLeft,),
              MyButton(icon: Icons.arrow_upward,function: fire,),
              MyButton(icon: Icons.arrow_forward,function: moveRight,),
            ],
          ),
          ))
        ],
      ),
    );
  }
}