import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/UIServices.dart';

class HistoricalPage extends StatefulWidget {
  final User loggedInUser;
  const HistoricalPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _HistoricalPageState createState() =>
      _HistoricalPageState(loggedInUser: loggedInUser);
}

class _HistoricalPageState extends State<HistoricalPage> {
  late User loggedInUser;
  _HistoricalPageState({required this.loggedInUser});
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73665d),
            Color(0xFFf6e09c),
            Color(0xFF887a61),
            Color(0xFF53382c),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: UIServices.makeCategoryPage('Historical',
              "assets/images/wingedHussars.jpg", allResult, loggedInUser),
        ),
      ),
    );
  }
}
