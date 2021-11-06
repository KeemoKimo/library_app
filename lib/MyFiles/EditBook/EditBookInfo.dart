import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';

import '../HomeScreen.dart';

class EditBookInfo extends StatefulWidget {
  const EditBookInfo({Key? key}) : super(key: key);

  @override
  _EditBookInfoState createState() => _EditBookInfoState();
}

class _EditBookInfoState extends State<EditBookInfo> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late User loggedInUser;
  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      } else {
        print('Null');
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookID =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    var titleController = TextEditingController(),
        authorController = TextEditingController(),
        numberOfPageController = TextEditingController(),
        descriptionController = TextEditingController(),
        languageController = TextEditingController(),
        publishedYearController = TextEditingController();
    var space20 = UIServices.makeSpace(20);
    final _formKey = GlobalKey<FormState>();

    uploadToFirestore() async {
      await DatabaseServices(uid: loggedInUser.uid).editBooksData(
          bookID.bookCategory,
          (titleController.text != "")
              ? titleController.text
              : bookID.bookTitle,
          (authorController.text != "")
              ? authorController.text
              : bookID.bookAuthor,
          (numberOfPageController.text != "")
              ? numberOfPageController.text
              : bookID.bookPages,
          (descriptionController.text != "")
              ? descriptionController.text
              : bookID.bookDescription,
          bookID.bookCover,
          (languageController.text != "")
              ? languageController.text
              : bookID.bookLanguage,
          (publishedYearController.text != "")
              ? publishedYearController.text
              : bookID.bookPublishedYear,
          bookID.bookTitle);
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFF1d1160),
              Color(0xFF333399),
              Color(0xFFb92b27),
              Color(0xFF4e54c8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                //! BOOK TITLE
                UIServices.makeSpace(40),
                UIServices.makeCustomTextField(
                    titleController, 'Title : ${bookID.bookTitle}', false, 0),
                //! BOOK AUTHOR
                space20,
                UIServices.makeCustomTextField(authorController,
                    'Author : ${bookID.bookAuthor}', false, 0),
                //! BOOK PAGES
                space20,
                UIServices.makeCustomTextField(numberOfPageController,
                    'Pages : ${bookID.bookPages}', true, 3),
                //! BOOK PUBLISHED YEAR
                space20,
                UIServices.makeCustomTextField(publishedYearController,
                    'Published : ${bookID.bookPublishedYear}', true, 5),
                //! BOOK LANGUAGE
                space20,
                UIServices.makeCustomTextField(languageController,
                    'Language : ${bookID.bookLanguage}', false, 0),
                //! BOOK DESCRIPTION
                space20,
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  width: double.infinity,
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                    maxLength: 1000,
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      labelText: "Book Description : ${bookID.bookDescription}",
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: UIServices.makeSpeedDial(
        Color(0xFF2B2784),
        Icons.restore,
        Colors.red,
        Colors.white,
        "Reset",
        () {
          setState(() {});
        },
        Icons.check,
        Colors.green,
        Colors.white,
        "Confirm Changes",
        () {
          uploadToFirestore();
          Navigator.pop(context);
          Navigator.pop(context);
          final snackBar = SnackBar(
            content: Text(
              'Your book has been editted successfully!',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}
