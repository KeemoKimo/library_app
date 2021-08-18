import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/main.dart';
import 'package:firebase_storage/firebase_storage.dart';

// ignore: camel_case_types
class addBookPage extends StatefulWidget {
  const addBookPage({Key? key}) : super(key: key);

  @override
  _addBookPageState createState() => _addBookPageState();
}

// ignore: camel_case_types
class _addBookPageState extends State<addBookPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String? userEmail = loggedInUser.email;
  late String? owner = userEmail;
  late String category = 'Choose a category';
  late String title;
  late String author;
  late String numberOfPages;
  late String description;
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        print(loggedInUser);
        build(context);
      });
    });
  }

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

  @override
  Widget build(BuildContext context) {
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
                        await DatabaseServices(uid: loggedInUser.uid)
                            .updateBooksData(category, title, author,
                                numberOfPages, description, owner!);
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
