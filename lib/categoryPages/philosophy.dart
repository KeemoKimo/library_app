import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class PhilosophyPage extends StatefulWidget {
  final User loggedInUser;
  const PhilosophyPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _PhilosophyPageState createState() =>
      _PhilosophyPageState(loggedInUser: loggedInUser);
}

class _PhilosophyPageState extends State<PhilosophyPage> {
  late User loggedInUser;
  _PhilosophyPageState({required this.loggedInUser});
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late var bookSnapshot = firestore.collection('books').get();
  List allResult = [];
  @override
  void initState() {
    super.initState();
    getAllBooks();
    print(loggedInUser.email);
    build(context);
  }

  getAllBooks() async {
    var data = await bookSnapshot;
    setState(() {
      allResult = data.docs;
    });
    return "Get all books completed!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFD2BFA9),
            Color(0xFFEADDCA),
            Color(0xFFA5BBD1),
            Color(0xFF83735D),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: UIServices.makeCategoryPage('Philosophy',
              "assets/images/plato_philosopher.jpg", allResult, loggedInUser),
        ),
      ),
    );
  }
}
