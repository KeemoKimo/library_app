import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/ScreenService/LoadingScreens/editing.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/Services/UIServices.dart';

import '../HomeScreen.dart';

class EditBook extends StatefulWidget {
  const EditBook({Key? key}) : super(key: key);

  @override
  _EditBookState createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  File? _image;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late User loggedInUser;
  late String? userEmail = loggedInUser.email;
  late String? owner = userEmail;
  bool loading = false;

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
        print(userEmail);
        build(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookID =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    String currentSelectedValue = '';
    currentSelectedValue = bookID.bookCategory;
    String? imageURL = bookID.bookCover;

    Future pickImage() async {
      final ImagePicker _picker = ImagePicker();
      try {
        XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
        setState(() {
          if (image == null) {
            print('Image was null');
          } else {
            _image = File(image.path);
          }
        });
      } catch (e) {
        print(e);
      }
    }

    Future uploadImage(BuildContext context) async {
      try {
        if (_image != null) {
          var snapshot = await storage
              .ref()
              .child('$userEmail/${bookID.bookTitle}.text cover')
              .putFile(_image!);
          String? downloadURL = await snapshot.ref.getDownloadURL();
          setState(() {
            imageURL = downloadURL;
          });
        } else {
          return imageURL;
        }
      } catch (e) {
        print(e);
      }
    }

    var mainBody = Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Edit '${bookID.bookTitle}' cover",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333399),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [UIServices.mainBoxShadow],
              ),
              width: 380,
              height: 550,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: _image != null
                    ? Image.file(
                        _image!,
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        bookID.bookCover,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.only(left: 30),
            child: FloatingActionButton(
              heroTag: 'swapImage',
              backgroundColor: Color(0xFF333399),
              onPressed: pickImage,
              child: Icon(CupertinoIcons.arrow_swap),
            ),
          ),
          Container(
            child: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () async {
                setState(() => loading = true);
                await uploadImage(context);
                await DatabaseServices(uid: loggedInUser.uid).editBooksData(
                    currentSelectedValue,
                    bookID.bookTitle,
                    bookID.bookAuthor,
                    bookID.bookPages,
                    bookID.bookDescription,
                    imageURL.toString(),
                    bookID.bookLanguage,
                    bookID.bookPublishedYear,
                    bookID.bookTitle);
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                );
              },
              child: Icon(Icons.check),
            ),
          )
        ],
      ),
    );
    return loading == true ? EditingLoading() : mainBody;
  }
}
