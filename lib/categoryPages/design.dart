import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/UIServices.dart';

class DesignPage extends StatefulWidget {
  final User loggedInUser;
  const DesignPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _DesignPageState createState() =>
      _DesignPageState(loggedInUser: loggedInUser);
}

class _DesignPageState extends State<DesignPage> {
  late User loggedInUser;
  _DesignPageState({required this.loggedInUser});
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
