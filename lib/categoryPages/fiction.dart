import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

// ignore: camel_case_types
class fictionPage extends StatefulWidget {
  const fictionPage({Key? key}) : super(key: key);

  @override
  _fictionPageState createState() => _fictionPageState();
}

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
late User loggedInUser;
var bookSnapshot = firestore.collection('books').get();
late String? username = '';
late String? userUID = loggedInUser.uid;
late String age = '';
File? file;
late String imageUrl = '';
List allResult = [];

// ignore: camel_case_types
class _fictionPageState extends State<fictionPage> {
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

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFf47835),
            Color(0xFFb0482e),
            Color(0xFFf36714),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          color: Colors.transparent,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: UIServices.makeCategoryPage('Fictional',
                "assets/images/fictional.jpg", allResult, loggedInUser),
          ),
        ),
      ),
    );
  }
}
