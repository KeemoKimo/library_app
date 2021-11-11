import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:lottie/lottie.dart';

class SendEmailLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 300,
              height: 300,
              child: Lottie.asset("assets/Animations/sendEmail.json"),
            ),
          ),
          UIServices.makeSpace(20),
          Center(
            child: Text(
              "Sending Your Mail ... ",
              style: TextStyle(
                  color: Color(0xFF4866E9),
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
