import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/BookInfo.dart';
import 'package:library_app/EditBook.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/otherUserFiles/otherUsersBooks.dart';
import 'package:library_app/otherUserFiles/otherUsersFavourites.dart';
import 'package:library_app/otherUserInfo.dart';
import 'HomeScreen.dart';
import 'DatabaseSerivces.dart';

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

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String? totalBooks = '';
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  AlertDialog makeDialog(String details) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/error.png'),
              ),
            ),
          ),
          Container(
            child: Text(
              "ERROR",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              details.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/books.jpeg'),
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.5), BlendMode.dstATop),
          fit: BoxFit.cover,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 170),
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 3,
                  animatedTexts: [
                    WavyAnimatedText(
                      'Welcome',
                      textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ],
                  isRepeatingAnimation: true,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
            ),
            Container(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          width: 30,
                          height: 30,
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/email-2.png'),
                          ),
                        ),
                        Container(
                          width: 340,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 10, right: 20),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: "Enter Email...",
                              labelStyle: TextStyle(color: Colors.white),
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
                            onChanged: (value) {
                              email = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          width: 30,
                          height: 30,
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('assets/images/password.png'),
                          ),
                        ),
                        Container(
                          width: 290,
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            obscureText: isObscure,
                            decoration: InputDecoration(
                              labelText: "Enter Password...",
                              labelStyle: TextStyle(color: Colors.white),
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
                            onChanged: (value) {
                              password = value;
                            },
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
                            margin: EdgeInsets.only(top: 20),
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
                    Container(
                      width: 200,
                      margin: EdgeInsets.only(top: 20, left: 150),
                      decoration: BoxDecoration(
                        color: Colors.yellow[800],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextButton(
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              width: 40,
                              height: 40,
                              child: Image(
                                image: AssetImage('assets/images/login.png'),
                              ),
                            ),
                          ],
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
                            UserCredential userCredential =
                                await auth.signInWithEmailAndPassword(
                                    email: email, password: password);
                            print("Sign In Successful");
                            //this line is to make user go second screen
                            Navigator.pushNamed(context, 'main');
                          } on FirebaseAuthException catch (e) {
                            switch (e.code) {
                              case "invalid-email":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'This email does not exist, please create one.');
                                  },
                                );
                                break;
                              case "wrong-password":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'Your password is incorrect, please check it again.');
                                  },
                                );
                                break;
                              case "user-not-found":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'This user credential is not found! Please create one, its free!!!');
                                  },
                                );
                                break;
                              case "user-disabled":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'This user account has already been disabled!');
                                  },
                                );
                                break;
                              case "too-many-requests":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'There is too many request being transmitted. Please slow down!');
                                  },
                                );
                                break;
                              case "operation-not-allowed":
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'This operation is not being allowed at the current moment!!!');
                                  },
                                );
                                break;
                              default:
                                print(e.code);
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return makeDialog(
                                        'Something went wrong with this log in, please check it again!!!');
                                  },
                                );
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 40),
                          child: Text(
                            "No account?",
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
                              'Register this credential !!',
                              style: TextStyle(
                                color: Colors.yellow[800],
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
                                        email: email, password: password);
                                print("USER CREATED !");
                                await DatabaseServices(
                                        uid: userCredential.user!.uid)
                                    .updateUserData(
                                  'new_User',
                                  'age',
                                  email,
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
                                Navigator.pushNamed(context, 'main');
                              } on FirebaseAuthException catch (e) {
                                switch (e.code) {
                                  case 'weak-password':
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return makeDialog(
                                              'Please create a password with more than 6 characters!!!');
                                        });
                                    break;
                                  case 'missing-email':
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return makeDialog(
                                              'Please enter in the email you want to create!!!');
                                        });
                                    break;
                                  case 'email-already-in-use':
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return makeDialog(
                                              'A user with this email already exists. Please choose a different email!!!');
                                        });
                                    break;
                                  default:
                                    print(e.code);
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return makeDialog(
                                            'This user provided credential could not be created!!!');
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
