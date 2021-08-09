import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      title: 'Library',
      //first route when app start
      initialRoute: 'home',
      //list of route that will be included in this project
      routes: {
        'home': (context) => const LoginPage(),
        'main': (context) => const HomeScreen(),
      },
      theme: ThemeData(primaryColor: Colors.blue),
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
            Text(
              "REGISTER",
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
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
                    color: Colors.blue,
                    width: 300,
                    height: 70,
                    child: TextButton(
                      onPressed: () async {
                        try {
                          UserCredential userCredential =
                              await auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print("USER CREATED !");
                          //this line is to make user go second screen
                          Navigator.pushNamed(context, 'main');
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "email-already-in-use":
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Container(
                                        color: Colors.red,
                                        child: Text("EMAIL ALREADY USED!!!"),
                                      ),
                                    );
                                  });
                              break;
                          }
                        }
                      },
                      child: Text(
                        "REGISTER ACCOUNT",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    margin: EdgeInsets.only(left: 45, right: 45, top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.green,
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  UserCredential userCredential =
                                      await auth.signInWithEmailAndPassword(
                                          email: email, password: password);
                                  print("Sign In Successful");
                                  //this line is to make user go second screen
                                  Navigator.pushNamed(context, 'main');
                                } on FirebaseException catch (e) {
                                  print(e.code);
                                  switch (e.code) {
                                    case "invalid-email":
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Container(
                                                color: Colors.red,
                                                child:
                                                    Text("INVALID EMAIL !!!"),
                                              ),
                                            );
                                          });
                                      break;
                                  }
                                }
                              },
                              child: Text(
                                "LOG-IN",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.brown,
                            child: TextButton(
                              onPressed: () async {
                                try {
                                  UserCredential result =
                                      await auth.signInAnonymously();
                                  print("Signed in Succesful");
                                  //this line is to make user go second screen
                                  Navigator.pushNamed(context, 'main');
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              child: Text(
                                "GUEST",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
