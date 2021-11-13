import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';
import 'package:lottie/lottie.dart';

class EditingLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Variables.themePurple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 400,
                height: 400,
                child: Lottie.asset("assets/Animations/editing.json"),
              ),
            ),
            UIServices.makeSpace(20),
            Center(
              child: Text(
                "NEARLY THERE ... ",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.none),
              ),
            )
          ],
        ),
      ),
    );
  }
}
