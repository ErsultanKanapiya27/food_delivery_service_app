import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  CircleImage(
       {
        this.radius = 30,
      });

  final double radius;
  // final ImageProvider imageProvider;

  @override
  Widget build(BuildContext context) {
    // wrapped around a column so that the avatar doesn't stretch
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: radius,
          backgroundImage: AssetImage('images/ers.jpeg'),
        )
      ],
    );
  }
}