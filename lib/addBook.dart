import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';
import 'Services/UIServices.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF1d1160),
            Color(0xFF720e9e),
            Color(0xFFe6e6fa),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
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
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () {
                if (isFavourite == false) {
                  isFavourite = true;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UIServices.showPopup(
                            "Book added to favourite successfully!",
                            "assets/images/heart.png",
                            false);
                      });
                } else {
                  isFavourite = false;
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return UIServices.showPopup(
                            "Book removed from favourite successfully!",
                            "assets/images/heart.png",
                            false);
                      });
                }
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //! USER PICK IMAGE
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
                    //! BOOK TITLE
                    UIServices.makeCustomTextField(
                        titleController, 'Enter book title...', false, 0),
                    UIServices.makeSpace(20),
                    //! BOOK AUTHOR
                    UIServices.makeCustomTextField(
                        authorController, 'Enter author name...', false, 0),
                    UIServices.makeSpace(20),
                    //! CHOOSE CATEGORY
                    Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
                              color: Colors.black,
                            ),
                            value: dropdownInitialValue,
                            items: categoryItems.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(
                                  items,
                                  style: TextStyle(
                                    color: Colors.black,
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
                    UIServices.makeSpace(20),
                    //! CHOOSE START DATE
                    Text(
                      'Start Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black,
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
                    UIServices.makeSpace(20),
                    //! CHOOSE END DATE
                    Text(
                      'End Date',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.black,
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
                    UIServices.makeSpace(20),
                    //! NUMBER OF PAGE
                    UIServices.makeCustomTextField(numberOfPageController,
                        'Enter number of page...', true, 5),
                    UIServices.makeSpace(20),
                    //! YEAR OF PUBLICATION
                    UIServices.makeCustomTextField(publishedYearController,
                        'Enter year of publication...', true, 10),
                    UIServices.makeSpace(20),
                    //! LANGUAGE
                    UIServices.makeCustomTextField(
                        languageController, 'Enter book language...', false, 0),
                    //! DESCRIPTION
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
                    //! ADD BOOK BTN
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
                            color: Colors.black,
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
                                return UIServices.showPopup(
                                    "Your book has been added successfully",
                                    'assets/images/success.png',
                                    false);
                              },
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return UIServices.showPopup(
                                    "There was an error adding in your inputted book data",
                                    'assets/images/error.png',
                                    true);
                              },
                            );
                          }
                        },
                      ),
                    ),
                    UIServices.makeSpace(20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
