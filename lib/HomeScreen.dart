import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String username = '';
  late String? userEmail = loggedInUser.email;
  late String age = '';
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }

  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: Drawer(
          child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: Text('$userEmail')),
                    ],
                  )),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: const Text('Edit profile'),
                  onTap: () async {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "USERNAME : ",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "SET USERNAME...",
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          username = value;
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
                                      child: Text(
                                        "Age : ",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "AGE...",
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          age = value;
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
                                      color: Colors.yellow[800],
                                      width: 300,
                                      height: 70,
                                      child: TextButton(
                                        onPressed: () async {
                                          try {
                                            await DatabaseServices(
                                                    uid: loggedInUser.uid)
                                                .updateUserData(
                                                    username, age, userEmail!);
                                            print("Edited User");
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    content: Container(
                                                      color: Colors.green,
                                                      child: Text(
                                                          "PROFILE CHANGED !!!"),
                                                    ),
                                                  );
                                                });
                                          } catch (e) {
                                            print(e.toString());
                                          }
                                        },
                                        child: Text(
                                          "CONFIRM CHANGE",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "CURRENT USER : $userEmail",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        });
                  },
                ),
                ListTile(
                  leading: Icon(Icons.favorite),
                  title: const Text('Favourites'),
                  onTap: () async {
                    await DatabaseServices(uid: loggedInUser.uid)
                        .userDataStream();
                  },
                ),
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.black,
                ),
                ListTile(
                  leading: Icon(Icons.logout_outlined),
                  title: const Text(
                    'Log Out',
                  ),
                  onTap: () async {
                    await auth.signOut();
                    print("Signed Out successful");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      final currentUserData = snapshot.data!.docs;
                      List<Text> userDatas = [];
                      for (var datas in currentUserData) {
                        var name = (datas.data() as Map)['userName'];
                        var email = (datas.data() as Map)['email'];
                        var age = (datas.data() as Map)['age'];

                        var userData =
                            Text('Name : $name , Email : $email , Age : $age');
                        userDatas.add(userData);
                      }
                      return Column(
                        children: userDatas,
                      );

                      return Column();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
