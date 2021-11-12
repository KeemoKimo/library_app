import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Variables.themePurple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SpinKitFoldingCube(
              color: Colors.white,
              duration: Duration(milliseconds: 1000),
              size: 50.0,
            ),
          ),
          UIServices.makeSpace(50),
          Center(
            child: Text(
              "Hold Tight !! ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  decoration: TextDecoration.none),
            ),
          )
        ],
      ),
    );
  }
}
