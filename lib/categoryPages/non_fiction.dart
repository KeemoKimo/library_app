import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/UIServices.dart';

// ignore: camel_case_types
class Non_Fiction_Page extends StatefulWidget {
  final User loggedInUser;
  const Non_Fiction_Page({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _Non_Fiction_PageState createState() =>
      _Non_Fiction_PageState(loggedInUser: loggedInUser);
}

// ignore: camel_case_types
class _Non_Fiction_PageState extends State<Non_Fiction_Page> {
  late User loggedInUser;
  _Non_Fiction_PageState({required this.loggedInUser});
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
            Color(0xFF8f7f6d),
            Color(0xFFece0d2),
            Color(0xFF4e4235),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: UIServices.makeCategoryPage('Non - Fiction',
              "assets/images/anneFrank.jpg", allResult, loggedInUser),
        ),
      ),
    );
  }
}
