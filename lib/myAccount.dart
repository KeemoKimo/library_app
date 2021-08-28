import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late String? userEmail = loggedInUser.email;
  late User loggedInUser;
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        print(loggedInUser.email);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'MY ACCOUNT',
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                          color: Colors.red,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    );
                  }
                  final users = snapshot.data!.docs;
                  List<Text> userDatas = [];
                  for (var user in users) {
                    var userName = (user.data() as Map)['userName'];
                    var email = (user.data() as Map)['email'];
                    var age = (user.data() as Map)['age'];

                    if (userEmail == email) {
                      final userStructure = Text(
                          'Username : $userName , email : $email , age : $age');
                      userDatas.add(userStructure);
                    }
                  }

                  return Column(
                    children: userDatas,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
