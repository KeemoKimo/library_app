import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/Services/UIServices.dart';

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [
              Color(0xFF333399),
              Color(0xFF1d1160),
              Color(0xFFfcb045),
              Color(0xFF720e9e),
              Color(0xFFfd1d1d),
            ],
          ),
        ),
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
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
              ),
              width: 380,
              height: 570,
              margin: EdgeInsets.only(top: 20),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: UIServices.makeSpeedDial(
          Color(0xFF2E2B89),
          Icons.change_circle,
          Colors.deepOrange,
          Colors.white,
          "Change Image",
          () => pickImage(),
          Icons.check,
          Colors.green,
          Colors.white,
          "Confirm Change",
          () async {
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
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
