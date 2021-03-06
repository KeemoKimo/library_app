import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/CategoryService.dart';

class SciFiPage extends StatefulWidget {
  final User loggedInUser;
  const SciFiPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _SciFiPageState createState() => _SciFiPageState(loggedInUser: loggedInUser);
}

class _SciFiPageState extends State<SciFiPage> {
  late User loggedInUser;
  _SciFiPageState({required this.loggedInUser});
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late var bookSnapshot = firestore.collection('books').get();
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
    return CategoryService.makeCategoryBody(
        Color(0xFF635478),
        Color(0xFF8F7A74),
        Color(0xFF6F5641),
        Color(0xFFD9A497),
        "Sci-Fi",
        "assets/images/sci_fi.jpg",
        allResult,
        loggedInUser,
        context);
  }
}
