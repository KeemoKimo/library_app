import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/CategoryService.dart';
import 'package:library_app/Services/UIServices.dart';

class ComicPage extends StatefulWidget {
  final User loggedInUser;
  const ComicPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _ComicPageState createState() => _ComicPageState(loggedInUser: loggedInUser);
}

class _ComicPageState extends State<ComicPage> {
  late User loggedInUser;
  _ComicPageState({required this.loggedInUser});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late var bookSnapshot = firestore.collection('books').get();
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
    return CategoryService.makeCategoryBody(
        Color(0xFFA82214),
        Color(0xFF108662),
        Color(0xFFF0AE27),
        Color(0xFF621D53),
        "Comic",
        "assets/images/comics.jpg",
        allResult,
        loggedInUser);
  }
}
