import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/InfoPages/BookInfo.dart';
import 'package:library_app/MyFiles/EditBook/EditBookCover.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/otherUserFiles/otherUsersBooks.dart';
import 'package:library_app/otherUserFiles/otherUsersFavourites.dart';
import 'package:library_app/otherUserFiles/otherUserInfo.dart';
import 'package:page_transition/page_transition.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';

//todo RUN APP
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      //first route when app start
      initialRoute: 'home',
      //list of route that will be included in this project
      routes: {
        'home': (context) => const LoginPage(),
        'main': (context) => const HomeScreen(),
        'bookInfo': (context) => const BookInfo(),
        'otherUserInfo': (context) => const OtherUserInfo(),
        'otherUserBooks': (context) => const OtherUserBooks(),
        'otherUserFavourites': (context) => const OtherUsersFavourites(),
        'editBook': (context) => const EditBook(),
        'aboutUs': (context) => const AboutUs(),
      },
      theme: ThemeData(primaryColor: Colors.blue, fontFamily: 'Lato'),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

//todo MAIN DESIGN CLASS
class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  String? totalBooks = '';
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

//! MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF5F021F),
            Color(0xFF473BF0),
          ],
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //!Authentication label
            Container(
              margin: EdgeInsets.only(top: 170),
              child: Text(
                "AUTHENTICATION",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //!Divider
            Container(
              margin: const EdgeInsets.all(20.0),
              child: Divider(
                color: Colors.white,
                height: 1,
                thickness: 1,
              ),
            ),
            //!The rest of the login form
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    //? EMAIL TEXT BOX
                    Container(
                      width: 340,
                      height: 50,
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter Email...",
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
                    ),
                    //? PASSWORD TEXT BOX / ICON
                    Row(
                      children: [
                        Container(
                          width: 290,
                          height: 50,
                          margin: EdgeInsets.only(top: 20, left: 35),
                          child: TextFormField(
                            controller: passwordController,
                            style: TextStyle(color: Colors.white),
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              hintText: "Password",
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
                                  color: Colors.blue,
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
                            margin: EdgeInsets.only(top: 20, left: 20),
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
                    //? LOG IN BUTTON
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(top: 20, left: 30, right: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        child: Container(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text(
                                  'Sign In succesful!',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            );
                          }
                          try {
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return UIServices.showPopup(
                                      'Please enter in your email and password!',
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
                              await auth.signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                              print("Sign In Successful");
                              //this line is to make user go second screen
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: HomeScreen(),
                                  type: PageTransitionType.rightToLeftWithFade,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case "invalid-email":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'This email does not exists!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              case "wrong-password":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'Incorrect password!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              case "user-not-found":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'User not found, please create one!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              case "user-disabled":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'This account has been disabled!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              case "too-many-requests":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'There is too many request! Please slow down!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              case "operation-not-allowed":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return UIServices.showPopup(
                                        'This operation is not allowed at the current moment!',
                                        'assets/images/error.png',
                                        true);
                                  },
                                );
                                break;
                              default:
                                print(e.code);
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
                    SizedBox(
                      height: 100,
                    ),
                    //? REGISTER ACCOUNT TEXT
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "No account ?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 13),
                          child: CupertinoButton(
                            child: Text(
                              'Register this credential !',
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'User has been created!',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                );
                              }
                              try {
                                UserCredential userCredential =
                                    await auth.createUserWithEmailAndPassword(
                                        email: emailController.text,
                                        password: passwordController.text);
                                print("USER CREATED !");
                                await DatabaseServices(
                                        uid: userCredential.user!.uid)
                                    .updateUserData(
                                  'new_User',
                                  'age',
                                  emailController.text,
                                  'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                  totalBooks!,
                                  'location',
                                  'about me',
                                  '',
                                  0,
                                  0,
                                  0,
                                  false,
                                  false,
                                  false,
                                  false,
                                );
                                //this line is to make user go second screen
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: HomeScreen(),
                                    type:
                                        PageTransitionType.leftToRightWithFade,
                                    duration: Duration(seconds: 5),
                                  ),
                                );
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
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
