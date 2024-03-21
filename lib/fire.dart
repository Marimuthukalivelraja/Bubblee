import 'package:flutter/material.dart';

class MyFire extends StatelessWidget {
  final fireX;
  final height;
  MyFire({this.height,this.fireX});
  @override
  Widget build(BuildContext context) {
    return Container(
                    alignment: Alignment(fireX, 1),
                     child: Container(
                      width: 2,
                      height: height,
                      color: Colors.grey,
                     ),
                   );
  }
}