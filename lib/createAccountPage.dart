import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
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
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    var mainBody = Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: RegisterPageService.bgGradient,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //!Registration label
            RegisterPageService.registerLabel,
            //! Main Registration Form
            UIServices.makeSpace(100),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //? USERNAME TEXT BOX
                  RegisterPageService.makeTextField(
                      340, "Create Username....", usernameController),
                  UIServices.makeSpace(20),
                  //? EMAIL TEXT BOX
                  RegisterPageService.makeTextField(
                      340, "Create Email....", emailController),
                  UIServices.makeSpace(20),
                  //? PASSWORD TEXT BOX / ICON
                  RegisterPageService.makeTextField(
                      340, "Create Password....", passwordController),
                  UIServices.makeSpace(60),
                  //? REGISTER BUTTON
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      child: Text(
                        'REGISTER !',
                        style: TextStyle(
                          color: Color(0xFF55224F),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
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
                          } else if (emailController.text.contains('@') ==
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
                            UserCredential userCredential =
                                await auth.createUserWithEmailAndPassword(
                                    email: emailController.text,
                                    password: passwordController.text);
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
                                  builder: (context) => HomeScreen()),
                            );
                          }
                        } on FirebaseAuthException catch (e) {
                          RegisterPageService.catchExceptions(e, context);
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
    );
    return mainBody;
  }
}
