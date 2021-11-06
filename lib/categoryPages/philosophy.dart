import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class PhilosophyPage extends StatefulWidget {
  const PhilosophyPage({Key? key}) : super(key: key);

  @override
  _PhilosophyPageState createState() => _PhilosophyPageState();
}

class _PhilosophyPageState extends State<PhilosophyPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late var bookSnapshot = firestore.collection('books').get();
  late String? username = '';
  late String? userUID = loggedInUser.uid;
  late String age = '';
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  File? file;
  late String imageUrl = '';
  List allResult = [];
  @override
  void initState() {
    super.initState();
    getAllBooks();
    getCurrentUser().whenComplete(
      () {
        setState(() {
          print(loggedInUser.email);
          build(context);
        });
      },
    );
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
