import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/ScreenService/LoadingScreens/creatingUser.dart';
import 'package:library_app/verifyaccountpage.dart';
import 'package:lottie/lottie.dart';
import 'Services/DatabaseSerivces.dart';
import 'Services/UIServices.dart';

class RegisterAccount extends StatefulWidget {
  const RegisterAccount({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterAccountState createState() => _RegisterAccountState();
}

class _RegisterAccountState extends State<RegisterAccount> {
  TextEditingController emailController = new TextEditingController(),
      passwordController = new TextEditingController(),
      usernameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  var now = new DateTime.now();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading == true
        ? CreatingUser()
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: Center(
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //!Registration label

                      Container(
                        width: 300,
                        height: 300,
                        padding: EdgeInsets.zero,
                        child: Lottie.asset(
                            "assets/Animations/registerAnimation.json"),
                      ),
                      //! Main Registration Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            //? EMAIL TEXT BOX
                            LoginPageService.makeAuthenticationTextField(
                                emailController,
                                false,
                                "Create Email...",
                                350,
                                0,
                                20),
                            //? USERNAME TEXT BOX
                            LoginPageService.makeAuthenticationTextField(
                                usernameController,
                                false,
                                "Create Username...",
                                350,
                                0,
                                20),
                            //? PASSWORD TEXT BOX
                            LoginPageService.makeAuthenticationTextField(
                                passwordController,
                                false,
                                "Create Password...",
                                350,
                                0,
                                20),
                            UIServices.makeSpace(20),
                            //? REGISTER BUTTON
                            Container(
                              width: double.infinity,
                              height: 50,
                              margin: EdgeInsets.only(
                                  left: 30, right: 30, bottom: 20),
                              decoration: LoginPageService.btnLoginProperties,
                              child: TextButton(
                                child: RegisterPageService.btnRegister,
                                onPressed: () async {
                                  try {
                                    //! CHECK IF USER FILL IN FORM
                                    if (emailController.text == "" ||
                                        passwordController.text == "" ||
                                        usernameController.text == "") {
                                      LoginPageService.showEmptyTextBoxPopup(
                                          context);
                                      //! CHECK IF EMAIL IS VALID
                                    } else if (emailController.text
                                            .contains('@') ==
                                        false) {
                                      LoginPageService.showProperEmailPopup(
                                          context);
                                    } else {
                                      setState(() => loading = true);
                                      UserCredential userCredential = await auth
                                          .createUserWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      //! SEND USER DATA INTO DATABASE
                                      await DatabaseServices(
                                              uid: userCredential.user!.uid)
                                          .updateUserData(
                                            usernameController.text,
                                            'Not yet set',
                                            emailController.text,
                                            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                            '',
                                            'Not yet set',
                                            'about me',
                                            '',
                                            now.day,
                                            now.month,
                                            now.year,
                                            false,
                                            false,
                                            false,
                                            false,
                                          )
                                          .then((_) => {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        VerifyEmail(),
                                                  ),
                                                ),
                                              });
                                    }
                                  } on FirebaseAuthException catch (e) {
                                    setState(() => loading = false);
                                    RegisterPageService.catchExceptions(
                                        e, context);
                                  } catch (e) {
                                    LoginPageService.showDefaultErrorPopup(
                                        context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
