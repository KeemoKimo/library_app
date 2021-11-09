import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/UIServices.dart';

class BiographyPage extends StatefulWidget {
  final User loggedInUser;
  const BiographyPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _BiographyPageState createState() =>
      _BiographyPageState(loggedInUser: loggedInUser);
}

class _BiographyPageState extends State<BiographyPage> {
  late User loggedInUser;
  _BiographyPageState({required this.loggedInUser});
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late var bookSnapshot = firestore.collection('books').get();
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  File? file;
  late String imageUrl = '';
  List allResult = [];
  @override
  void initState() {
    super.initState();
    getAllBooks();
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
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF2A1F14),
            Color(0xFF78705D),
            Color(0xFFEFE7CF),
            Color(0xFFC9BA9D),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: UIServices.makeCategoryPage('Biography',
              "assets/images/sittingBull.jpg", allResult, loggedInUser),
        ),
      ),
    );
  }
}
