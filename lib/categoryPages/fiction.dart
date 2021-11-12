import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/CategoryService.dart';

// ignore: camel_case_types
class fictionPage extends StatefulWidget {
  final User loggedInUser;
  const fictionPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _fictionPageState createState() =>
      _fictionPageState(loggedInUser: loggedInUser);
}

// ignore: camel_case_types
class _fictionPageState extends State<fictionPage> {
  late User loggedInUser;
  _fictionPageState({required this.loggedInUser});
  FirebaseAuth auth = FirebaseAuth.instance;
  late FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  Widget build(BuildContext context) {
    return CategoryService.makeCategoryBody(
        Color(0xFFf47835),
        Color(0xFFb0482e),
        Color(0xFFf36714),
        Color(0xFFf47835),
        "Fictional",
        "assets/images/fictional.jpg",
        allResult,
        loggedInUser);
  }
}
