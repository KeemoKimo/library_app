import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

// ignore: camel_case_types
class addBookPage extends StatefulWidget {
  const addBookPage({Key? key}) : super(key: key);

  @override
  _addBookPageState createState() => _addBookPageState();
}

// ignore: camel_case_types
class _addBookPageState extends State<addBookPage> {
  File? _image;
  String? imageURL;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late User loggedInUser;
  late String? userEmail = loggedInUser.email;
  late String? owner = userEmail;
  late String category = 'Choose a category';
  late String title;
  late String author;
  late String numberOfPages;
  late String description;

  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
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
        print(loggedInUser);
        build(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final ImagePicker _picker = ImagePicker();
      XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
      print('eee');

      setState(() {
        if (image == null) {
          print('Image was null');
        } else {
          _image = File(image.path);
        }
      });
    }

    Future uploadImage(BuildContext context) async {
      // Reference storageReference =
      //     storage.ref().child('$userEmail/$title cover');
      // UploadTask uploadTask = storageReference.putFile(_image!);
      var snapshot =
          await storage.ref().child('$userEmail/$title cover').putFile(_image!);
      String? downloadURL = await snapshot.ref.getDownloadURL();
      setState(() {
        imageURL = downloadURL;
      });
    }

    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Books'),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Choose book Cover',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    width: 200,
                    height: 300,
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            'https://www.brother.ca/resources/images/no-product-image.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  IconButton(
                    color: Colors.black,
                    onPressed: () => pickImage(),
                    icon: Icon(Icons.add_a_photo),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Book Title',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter Book title...",
                        labelStyle: TextStyle(color: Colors.black),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        title = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Author Name',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the book author name...",
                        labelStyle: TextStyle(color: Colors.black),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        author = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the book category",
                        labelStyle: TextStyle(color: Colors.black),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        category = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Number of pages',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the number of pages...",
                        labelStyle: TextStyle(color: Colors.black),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        numberOfPages = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Write a brief description...",
                        labelStyle: TextStyle(color: Colors.black),
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
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        description = value;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CupertinoButton(
                      color: Colors.yellow[700],
                      child: Text('Add Book !'),
                      onPressed: () async {
                        await uploadImage(context);
                        print('Finished updating book data');
                        await DatabaseServices(uid: loggedInUser.uid)
                            .updateBooksData(category, title, author,
                                numberOfPages, description, owner!, imageURL!);
                        print('Uploaded Image');
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              backgroundColor: Colors.lightGreen,
                              content: Text(
                                "Book Added Succesfully!",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            );
                          },
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
