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
      decoration: ResetAndVerifyService.resetPassBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                //! RESET PASSWORD LABEL
                ResetAndVerifyService.resetPassText,
                UIServices.makeSpace(20),
                //! EMAIL TEXTFIELD
                LoginPageService.makeAuthenticationTextField(emailController,
                    false, "Enter your email...", double.infinity, 20, 20),
                UIServices.makeSpace(20),
                //! SEND REQUEST BUTTON
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(left: 30, right: 30),
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
                        ResetAndVerifyService.showSentRequestDialog(context);
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
