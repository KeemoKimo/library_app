import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({Key? key}) : super(key: key);

  @override
  _DesignPageState createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
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

  //! GET ALL THE BOOKS FROM FIREBASE AND STORE IT IN A LIST
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFE6E6E6),
            Color(0xFF000000),
            Color(0xFF8B8B8B),
            Color(0xFF5F5F5F),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: UIServices.makeCategoryPage(
              'Design', "assets/images/design.jpg", allResult, loggedInUser),
        ),
      ),
    );
  }
}
