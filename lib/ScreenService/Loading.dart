import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:library_app/Services/UIServices.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF4D028A),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SpinKitFoldingCube(
              color: Colors.white,
              duration: Duration(milliseconds: 1000),
              size: 20.0,
            ),
          ),
          UIServices.makeSpace(50),
          Center(
            child: Text(
              "Hold Tight !! ",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  decoration: TextDecoration.none),
            ),
          )
        ],
      ),
    );
  }
}
