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
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
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
            DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20.0,
              ),
              child: AnimatedTextKit(
                totalRepeatCount: 5,
                animatedTexts: [
                  WavyAnimatedText(
                    'Welcome !',
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter Email...",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.blue,
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Enter Password...",
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
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
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CupertinoButton(
                      color: Colors.yellow[700],
                      child: Text('Register Account'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Registered Succesful!')),
                          );
                        }
                        try {
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print("USER CREATED !");
                          await DatabaseServices(uid: userCredential.user!.uid)
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
                          print(e.toString());
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CupertinoButton(
                      color: Colors.green[700],
                      child: Text('Sign In'),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Sign In succesful!')),
                          );
                        }
                        try {
                          UserCredential userCredential =
                              await auth.signInWithEmailAndPassword(
                                  email: email, password: password);

                          print("Sign In Successful");
                          //this line is to make user go second screen
                          Navigator.pushNamed(context, 'main');
                        } on FirebaseException catch (e) {
                          print(e.code);
                          if (e.code == 'user-not-found') {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    color: Colors.red,
                                    child: Text("USER NOT FOUND!"),
                                  ),
                                );
                              },
                            );
                          } else {
                            print(e);
                          }
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
}
