import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:image_picker/image_picker.dart';
import '../Services/UIServices.dart';

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
  var titleController = TextEditingController(),
      authorController = TextEditingController(),
      numberOfPageController = TextEditingController(),
      descriptionController = TextEditingController(),
      languageController = TextEditingController(),
      publishedYearController = TextEditingController();
  DateTime _startDate = DateTime.now(), _endDate = DateTime.now();
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
  var pickImagePageKey = GlobalKey(),
      basicInfoPageKey = GlobalKey(),
      lastPageKey = GlobalKey();
  bool loading = false;
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

    uploadToDatabase() async {
      try {
        await uploadImage(context);
        print('Finished updating book data');
        await DatabaseServices(uid: loggedInUser.uid).updateBooksData(
          dropdownInitialValue,
          titleController.text,
          authorController.text,
          numberOfPageController.text,
          descriptionController.text,
          owner!,
          imageURL!,
          languageController.text,
          publishedYearController.text,
          _startDate,
          _endDate,
          false,
        );
        print('Uploaded Image');
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return UIServices.showPopup("Your book has been added successfully",
                'assets/images/success.png', false);
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
    }

    final _formKey = GlobalKey<FormState>();

    //! ALL SCREENS
    var mainBody = Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                //! FIRST SCREEN - USER PICK IMAGE
                Container(
                  padding: EdgeInsets.only(top: 50),
                  key: pickImagePageKey,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 600,
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [UIServices.mainBoxShadow],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/noBookCover.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      //! FLOATY BUTTON
                      UIServices.makeSpeedDial(
                        Color(0xFF4D028A),
                        Icons.arrow_forward,
                        Colors.green,
                        Colors.white,
                        "Next Page",
                        () => (_image != null)
                            ? UIServices.scrollToItem(basicInfoPageKey)
                            : showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return UIServices.showPopup(
                                      "Please select an image first!",
                                      "assets/images/error.png",
                                      true);
                                },
                              ),
                        Icons.add_a_photo,
                        Color(0xFF333399),
                        Colors.white,
                        "Choose a cover",
                        () => pickImage(),
                      ),
                    ],
                  ),
                ),
                //! SECOND SCREEN - BASIC INFO
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ScreenBG/2ndScreenAddBook.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  key: basicInfoPageKey,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Stack(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              //! BOOK TITLE
                              UIServices.makeCustomTextField(titleController,
                                  'Enter book title...', context, true, 40),
                              UIServices.makeSpace(20),
                              //! BOOK AUTHOR
                              UIServices.makeCustomTextField(authorController,
                                  'Enter author name...', context, true, 40),
                              UIServices.makeSpace(20),
                              //! NUMBER OF PAGE
                              UIServices.makeCustomTextField(
                                  numberOfPageController,
                                  'Enter number of page...',
                                  context,
                                  true,
                                  5),
                              UIServices.makeSpace(20),
                              //! YEAR OF PUBLICATION
                              UIServices.makeCustomTextField(
                                  publishedYearController,
                                  'Enter year of publication...',
                                  context,
                                  true,
                                  7),
                              UIServices.makeSpace(20),
                              //! LANGUAGE
                              UIServices.makeCustomTextField(languageController,
                                  'Enter book language...', context, true, 10),
                              //! DESCRIPTION
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
                                    counterStyle:
                                        TextStyle(color: Colors.white),
                                    labelText: "Write a brief description...",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
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
                        //! FLOATY BUTTON basic info page
                        Container(
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height),
                          child: UIServices.makeSpeedDial(
                            Color(0xFFf83600),
                            Icons.arrow_forward,
                            Colors.green,
                            Colors.white,
                            "Next page",
                            () => _formKey.currentState!.validate()
                                ? UIServices.scrollToItem(lastPageKey)
                                : print("error"),
                            Icons.arrow_back,
                            Colors.red,
                            Colors.white,
                            "Previous Page",
                            () => UIServices.scrollToItem(pickImagePageKey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //! THIRD SCREEN FINISHING
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/ScreenBG/3rdScreenAddBooks.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  key: lastPageKey,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Column(
                            children: [
                              Text(
                                'Category',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D028A),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFF4D028A),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    fillColor: Color(0xFF4D028A),
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                      canvasColor: Color(0xFF4D028A),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        isExpanded: true,
                                        elevation: 10,
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.white,
                                        ),
                                        value: dropdownInitialValue,
                                        items:
                                            categoryItems.map((String items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Text(
                                              items,
                                              style: TextStyle(
                                                color: Colors.white,
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
                              ),
                              //! CHOOSE START DATE
                              UIServices.makeSpace(50),
                              Text(
                                'Start Date',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D028A),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Color(0xFF4D028A),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate: DateTime.now(),
                                    );

                                    if (pickedDate != null &&
                                        pickedDate != DateTime.now()) {
                                      setState(() {
                                        _startDate = DateTime(pickedDate.year,
                                            pickedDate.month, pickedDate.day);
                                      });
                                    } else {
                                      _startDate = DateTime.now();
                                    }
                                  },
                                ),
                              ),
                              //! CHOOSE END DATE
                              UIServices.makeSpace(50),
                              Text(
                                'End Date',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4D028A),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                decoration: BoxDecoration(
                                  color: Color(0xFF4D028A),
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
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white,
                                  ),
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate:
                                          DateTime(DateTime.now().year - 5),
                                      lastDate: DateTime.now(),
                                    );
                                    if (pickedDate != null &&
                                        pickedDate != DateTime.now()) {
                                      setState(() {
                                        _endDate = DateTime(pickedDate.year,
                                            pickedDate.month, pickedDate.day);
                                      });
                                    } else {
                                      _endDate = DateTime.now();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        UIServices.makeSpace(100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: FloatingActionButton(
                                backgroundColor: Colors.red,
                                onPressed: () =>
                                    UIServices.scrollToItem(basicInfoPageKey),
                                child: Icon(Icons.arrow_back),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: FloatingActionButton(
                                backgroundColor: Colors.green,
                                onPressed: () async {
                                  setState(() => loading = true);
                                  await uploadToDatabase();
                                },
                                child: Icon(Icons.check),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return loading == true ? Loading() : mainBody;
  }
}
