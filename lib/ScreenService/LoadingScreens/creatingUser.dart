import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:lottie/lottie.dart';

class CreatingUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                width: 300,
                height: 300,
                child: Lottie.asset("assets/Animations/creatingUser.json"),
              ),
            ),
            UIServices.makeSpace(20),
            Center(
              child: Text(
                "Creating your Account ... ",
                style: TextStyle(
                    color: Color(0xFF4D028A),
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
