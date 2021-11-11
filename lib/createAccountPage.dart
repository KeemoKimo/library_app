import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/ScreenService/Loading.dart';
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
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //!Registration label
                    RegisterPageService.registerLabel,
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/registerVector.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    //! Main Registration Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //? USERNAME TEXT BOX
                          LoginPageService.makePasswordTextField(
                              usernameController,
                              false,
                              "Enter Username...",
                              350,
                              0,
                              20),
                          //? EMAIL TEXT BOX
                          LoginPageService.makePasswordTextField(
                              emailController,
                              false,
                              "Enter email...",
                              350,
                              0,
                              20),
                          //? PASSWORD TEXT BOX
                          LoginPageService.makePasswordTextField(
                              passwordController,
                              false,
                              "Enter Password...",
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UIServices.showPopup(
                                            'Please enter in all the fields!',
                                            'assets/images/error.png',
                                            true);
                                      },
                                    );
                                    //! CHECK IF EMAIL IS VALID
                                  } else if (emailController.text
                                          .contains('@') ==
                                      false) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UIServices.showPopup(
                                            'Please enter a proper email',
                                            'assets/images/error.png',
                                            true);
                                      },
                                    );
                                  } else {
                                    setState(() => loading = true);
                                    UserCredential userCredential = await auth
                                        .createUserWithEmailAndPassword(
                                            email: emailController.text,
                                            password: passwordController.text);
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
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  setState(() => loading = false);
                                  RegisterPageService.catchExceptions(
                                      e, context);
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UIServices.showPopup(
                                          'Something went wrong, please try again!',
                                          'assets/images/error.png',
                                          true);
                                    },
                                  );
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
          );
  }
}
