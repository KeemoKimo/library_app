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
  var titleController = TextEditingController();
  var authorController = TextEditingController();
  var numberOfPageController = TextEditingController();
  var descriptionController = TextEditingController();
  var languageController = TextEditingController();
  var publishedYearController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String dropdownInitialValue = 'Fictional';
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
        print(userEmail);
        build(context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Future pickImage() async {
      final ImagePicker _picker = ImagePicker();
      try {
        XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
        print('eee');

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
        var snapshot = await storage
            .ref()
            .child('$userEmail/$titleController.text cover')
            .putFile(_image!);
        String? downloadURL = await snapshot.ref.getDownloadURL();
        setState(() {
          imageURL = downloadURL;
        });
      } catch (e) {
        print(e);
      }
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 5, color: Colors.black),
                    ),
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
                      controller: titleController,
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
                      controller: authorController,
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
                  DropdownButton(
                    elevation: 10,
                    icon: Icon(Icons.arrow_drop_down),
                    value: dropdownInitialValue,
                    items: categoryItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownInitialValue = newValue!;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: CupertinoDatePicker(
                      initialDateTime: _startDate,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (dateTime) {
                        setState(() {
                          _startDate = dateTime;
                        });
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: CupertinoDatePicker(
                      initialDateTime: _endDate,
                      mode: CupertinoDatePickerMode.dateAndTime,
                      onDateTimeChanged: (dateTime) {
                        setState(() {
                          _endDate = dateTime;
                        });
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
                      controller: numberOfPageController,
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Published Year',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: publishedYearController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the year the book is published",
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: languageController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: "Enter the book language",
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
                      controller: descriptionController,
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: CupertinoButton(
                      color: Colors.yellow[700],
                      child: Text('Add Book !'),
                      onPressed: () async {
                        print(userEmail);
                        print(titleController);
                        await uploadImage(context);
                        print('Finished updating book data');
                        await DatabaseServices(uid: loggedInUser.uid)
                            .updateBooksData(
                          dropdownInitialValue,
                          titleController.text,
                          authorController.text,
                          numberOfPageController.text,
                          descriptionController.text,
                          owner!,
                          imageURL!,
                          languageController.text,
                          publishedYearController.text,
                          _startDate.toString(),
                          _endDate.toString(),
                        );
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
