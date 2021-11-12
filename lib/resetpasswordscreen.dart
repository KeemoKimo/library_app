import 'package:flutter/material.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ScreenBG/ResetPasswordBG.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                //! RESET PASSWORD LABEL
                Text(
                  "Reset your password",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Variables.themePurple,
                      fontSize: 30),
                ),
                UIServices.makeSpace(20),
                //! EMAIL TEXTFIELD
                LoginPageService.makeAuthenticationTextField(emailController,
                    false, "Enter your email...", double.infinity, 20, 20),
                //! SEND REQUEST BUTTON
                UIServices.makeSpace(20),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  decoration: LoginPageService.btnLoginProperties,
                  child: TextButton(
                    child: RegisterPageService.btnSendRequest,
                    onPressed: () async {
                      if (emailController.text == "") {
                        LoginPageService.showEmptyTextBoxPopup(context);
                      } else if (emailController.text.contains("@") == false) {
                        LoginPageService.showProperEmailPopup(context);
                      } else {
                        Variables.auth.sendPasswordResetEmail(
                            email: emailController.text);
                        print(emailController.text);
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UIServices.showPopup(
                                  "Request sent! Please check your email.",
                                  "assets/images/success.png",
                                  false);
                            });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
