import 'dart:async';

import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:lottie/lottie.dart';
import 'package:library_app/main.dart';

class MainSplashScreen extends StatefulWidget {
  const MainSplashScreen({Key? key}) : super(key: key);

  @override
  _MainSplashScreenState createState() => _MainSplashScreenState();
}

class _MainSplashScreenState extends State<MainSplashScreen> {
  void iniState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 4),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      ),
    );
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xFF4D028A)),
              width: 300,
              height: 300,
              child: Lottie.asset("assets/bookSplashScreen.json"),
            ),
            UIServices.makeSpace(30),
            Text(
              "LIBRARY",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4D028A)),
            ),
            UIServices.makeSpace(30),
            Text(
              "By Bunthong",
              style: TextStyle(fontSize: 20, color: Color(0xFF4D028A)),
            ),
          ],
        ),
      ),
    );
  }
}
