import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';
import 'package:lottie/lottie.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;
  late bool isVisible = false;

  @override
  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      setState(() {
        isVisible = true;
      });
    });
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ScreenBG/VerifyEmailBG.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //! ANIMATION
              Container(
                width: 300,
                height: 300,
                child: Lottie.asset("assets/Animations/verifyEmail.json"),
              ),

              Text(
                "A Verification is sent to : ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              UIServices.makeSpace(30),
              Text(
                user.email!,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Variables.themePurple,
                    fontSize: 25),
              ),
              UIServices.makeSpace(30),
              Text(
                "Please check and verify it.",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              UIServices.makeSpace(50),
              //! SKIP VERIFICATION TEXT, USER HAVE OPTION TO EITHER SKIP OR VERIFY
              Visibility(
                visible: isVisible,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                      color: Variables.themePurple,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [UIServices.mainBoxShadow]),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      "Skip Verification",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //! FUNCTION TO LISTEN IF THE EMAIL IS VERIFIED

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }
}
