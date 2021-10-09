import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';

import 'HomeScreen.dart';

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

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  bool isFavourite = false;

  var categoryItems = [
    'Fictional',
    'Non - Fiction',
    'Historical',
    'Philosophy',
    'Sci-Fi',
    'Comic',
    'Biography',
    'Design'
  ];

  Container customDivider() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.black,
      ),
    );
  }

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
    var titleController = TextEditingController(text: bookID.bookTitle);
    var authorController = TextEditingController(text: bookID.bookAuthor);
    var numberOfPageController = TextEditingController(text: bookID.bookPages);
    var descriptionController =
        TextEditingController(text: bookID.bookDescription);
    var languageController = TextEditingController(text: bookID.bookLanguage);
    var publishedYearController =
        TextEditingController(text: bookID.bookPublishedYear);
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
              .child('$userEmail/$titleController.text cover')
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
      appBar: AppBar(
        title: Text(
          'EDIT BOOK',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Color(0xFFF7E3AF),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.black,
            ),
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Delete Book'),
                  content: Text(
                      'Are you sure you want to edit ${bookID.bookTitle} ?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('Yes'),
                      isDestructiveAction: true,
                      onPressed: () async {
                        await uploadImage(context);
                        print('Finished updating book data');
                        await DatabaseServices(uid: loggedInUser.uid)
                            .editBooksData(
                                currentSelectedValue,
                                titleController.text,
                                authorController.text,
                                numberOfPageController.text,
                                descriptionController.text,
                                imageURL.toString(),
                                languageController.text,
                                publishedYearController.text,
                                bookID.bookTitle);
                        print('Uploaded Image');
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.lightGreen,
                              content: Text(
                                "Book Editted Succesfully!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFF7E3AF),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                customDivider(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Please Choose a book Cover',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 5,
                      color: Colors.black,
                    ),
                  ),
                  width: 300,
                  height: 500,
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
                IconButton(
                  color: Colors.white,
                  onPressed: () => pickImage(),
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Colors.black,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: titleController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: titleController.text == ''
                          ? bookID.bookTitle
                          : titleController.text,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    // onChanged: (value) {
                    //   titleController = value;
                    // },
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter some text';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: authorController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: authorController.text == ''
                          ? bookID.bookAuthor
                          : authorController.text,
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 5,
                    controller: numberOfPageController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "${bookID.bookPages} pages",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 10,
                    controller: publishedYearController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "Published ${bookID.bookPublishedYear}",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    controller: languageController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "${bookID.bookLanguage}",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 1000,
                    controller: descriptionController,
                    maxLines: 10,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                        color: Colors.black,
                      ),
                      labelText: "${bookID.bookDescription}",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                customDivider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
