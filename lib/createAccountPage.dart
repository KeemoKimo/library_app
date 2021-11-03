import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
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
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF833ab4),
              Color(0xFFfd1d1d),
              Color(0xFFfcb045),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //!Registration label
            Container(
              margin: EdgeInsets.only(left: 50, top: 100),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Create an Account!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //! Main Registration Form
            UIServices.makeSpace(130),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  //? USERNAME TEXT BOX
                  makeTextField(340, "Create Username....", usernameController),
                  UIServices.makeSpace(20),
                  //? EMAIL TEXT BOX
                  makeTextField(340, "Create Email....", emailController),
                  UIServices.makeSpace(20),
                  //? PASSWORD TEXT BOX / ICON
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 37),
                        child: makeTextField(
                            300, "Create Password....", passwordController),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isObscure == true) {
                              isObscure = false;
                            } else {
                              isObscure = true;
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10, left: 10),
                          width: 30,
                          height: 30,
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/eye.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  UIServices.makeSpace(100),
                  //? REGISTER BUTTON
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.only(left: 30, right: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextButton(
                      child: Text(
                        'REGISTER !',
                        style: TextStyle(
                          color: Color(0xFFE02242),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                'Account Created!',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          );
                        }
                        try {
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
                          switch (e.code) {
                            case 'weak-password':
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'Create a password with more than 6 characters!',
                                        'assets/images/error.png',
                                        true);
                                  });
                              break;
                            case 'missing-email':
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'Enter in your email to create!',
                                        'assets/images/error.png',
                                        true);
                                  });
                              break;
                            case 'email-already-in-use':
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'This user already exists! Please make a unique one!',
                                        'assets/images/error.png',
                                        true);
                                  });
                              break;
                            default:
                              print(e.code);
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return UIServices.showPopup(
                                      'The provided credintial could not be created!',
                                      'assets/images/error.png',
                                      true);
                                },
                              );
                          }
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
  }

  Container makeTextField(double width, String hintText,
      TextEditingController textEditingController) {
    return Container(
      width: width,
      height: 50,
      child: TextFormField(
        controller: textEditingController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      ),
    );
  }
}
