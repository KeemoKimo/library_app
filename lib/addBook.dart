import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';

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
  DateTime _nowDate = DateTime.now();
  String dropdownInitialValue = 'Fictional';
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
        backgroundColor: Color(0xFFB03A2E),
        title: Text(
          'Add a new Book',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Mark As Favourite'),
                  content:
                      Text('Do you want to set this book as a favourite ?'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text(
                        'No',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.green),
                      ),
                      isDestructiveAction: true,
                      onPressed: () {
                        print(isFavourite);
                        isFavourite = true;
                        Navigator.pop(context);
                        print(isFavourite);
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
        color: Color(0xFFB03A2E),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Text(
                      'Please Choose a book Cover',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 5, color: Colors.black),
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
                            'https://www.brother.ca/resources/images/no-product-image.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                  IconButton(
                    color: Colors.white,
                    onPressed: () => pickImage(),
                    icon: Icon(Icons.add_a_photo),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: titleController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter Book title...",
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter the Author's name...",
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                    ),
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          elevation: 10,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Color(0xFFB03A2E),
                          ),
                          value: dropdownInitialValue,
                          items: categoryItems.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                items,
                                style: TextStyle(
                                  color: Color(0xFFB03A2E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownInitialValue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        _startDate.day.toString() +
                            " / " +
                            _startDate.month.toString() +
                            " / " +
                            _startDate.year.toString(),
                        style: TextStyle(
                          color: Color(0xFFB03A2E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFB03A2E),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _nowDate,
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null &&
                            pickedDate != DateTime.now()) {
                          setState(() {
                            _startDate = pickedDate;
                          });
                        } else {
                          _startDate = DateTime.now();
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        _endDate.day.toString() +
                            " / " +
                            _endDate.month.toString() +
                            " / " +
                            _endDate.year.toString(),
                        style: TextStyle(
                          color: Color(0xFFB03A2E),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFFB03A2E),
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _nowDate,
                          firstDate: DateTime(DateTime.now().year - 5),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null &&
                            pickedDate != DateTime.now()) {
                          setState(() {
                            _endDate = pickedDate;
                          });
                        } else {
                          _endDate = DateTime.now();
                        }
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      maxLength: 5,
                      controller: numberOfPageController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: Colors.white),
                        labelText: "Enter the number of pages...",
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      maxLength: 10,
                      controller: publishedYearController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: Colors.white),
                        labelText: "Enter the year the book is published",
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      controller: languageController,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Enter the book language",
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
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(color: Colors.white),
                        labelText: "Write a brief description...",
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
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      child: Text(
                        'Add Book !',
                        style: TextStyle(
                          color: Color(0xFFB03A2E),
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      onPressed: () async {
                        try {
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
                            isFavourite,
                          );
                          print('Uploaded Image');
                          await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/success.png'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "ADDED",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.green,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      child: Text(
                                        'Your book has been added into our database successfully. You can delete it or edit it later!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.green,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                          Navigator.pop(context);
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/error.png'),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "ERROR",
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, top: 20),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 20, left: 20, right: 20),
                                      child: Text(
                                        'Please check your input data again!!!',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.all(20),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        }
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
