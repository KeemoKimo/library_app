import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

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

    timer = Timer.periodic(Duration(seconds: 3), (timer) {
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
    Timer(Duration(seconds: 4), () {
      setState(() {
        isVisible = true;
      });
    });
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
        decoration: ResetAndVerifyService.verifyEmailBg,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //! ANIMATION
                ResetAndVerifyService.verifyAnimation,
                //! TEXT SHOWING USER THAT VERIFY REQUEST IS SENT
                ResetAndVerifyService.verifyEmailText("Verification sent to"),
                UIServices.makeSpace(30),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    user.email!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Variables.themePurple,
                        fontSize: 25),
                  ),
                ),
                UIServices.makeSpace(30),
                ResetAndVerifyService.verifyEmailText(
                    "Please check and verify it!"),
                UIServices.makeSpace(50),
                //! SKIP VERIFICATION TEXT, USER HAVE OPTION TO EITHER SKIP OR VERIFY
                Visibility(
                  visible: isVisible,
                  child: ResetAndVerifyService.makeVerifyButton(context),
                ),
              ],
            ),
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
      ResetAndVerifyService.showSuccessVerifyPopup(context);
      timer.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
  }
}
