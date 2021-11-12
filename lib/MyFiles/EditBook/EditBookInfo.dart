import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';

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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/ScreenBG/EditBookInfoBG.png"),
            fit: BoxFit.cover,
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
                UIServices.makeCustomTextField(titleController,
                    'Title : ${bookID.bookTitle}', context, true, 40),
                //! BOOK AUTHOR
                space20,
                UIServices.makeCustomTextField(authorController,
                    'Author : ${bookID.bookAuthor}', context, true, 20),
                //! BOOK PAGES
                space20,
                UIServices.makeCustomTextField(numberOfPageController,
                    'Pages : ${bookID.bookPages}', context, true, 5),
                //! BOOK PUBLISHED YEAR
                space20,
                UIServices.makeCustomTextField(
                    publishedYearController,
                    'Published : ${bookID.bookPublishedYear}',
                    context,
                    true,
                    7),
                //! BOOK LANGUAGE
                space20,
                UIServices.makeCustomTextField(languageController,
                    'Language : ${bookID.bookLanguage}', context, true, 10),
                //! BOOK DESCRIPTION
                space20,
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF4D028A),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: descriptionController,
                    maxLines: 10,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(color: Colors.white),
                      labelText: "Description : ${bookID.bookDescription}",
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none),
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      errorStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: 0.1,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter in the field!!";
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.red,
              onPressed: () {
                setState(() {});
              },
              child: Icon(Icons.restore),
            ),
          ),
          Container(
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Colors.green,
              onPressed: () async {
                Loading();
                uploadToFirestore();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
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
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
    );
  }
}
