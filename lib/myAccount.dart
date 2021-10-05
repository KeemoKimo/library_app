import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:country_picker/country_picker.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DatabaseServices dbService;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late String? userEmail = loggedInUser.email;
  late String? userUID = loggedInUser.uid;
  late User loggedInUser;
  late String? profileURL = '';
  late File userProfilePicture;
  late String? userName = '';
  late String? age = '';
  late String? totalBooks = '';
  late String? totalFavourites = '';
  late String? currentLocation = '';
  late String? about = '';
  late int? createdDateYear = loggedInUser.metadata.creationTime!.year;
  late int? createdDateMonth = loggedInUser.metadata.creationTime!.month;
  late int? createdDateDate = loggedInUser.metadata.creationTime!.day;

  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        print(loggedInUser.email);
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

  countBooks() async {
    QuerySnapshot _myDoc = await firestore
        .collection('books')
        .where('owner',
            isEqualTo: loggedInUser.email.toString()) //cannot use ==
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    totalBooks = _myDocCount.length.toString();
    DatabaseServices(uid: loggedInUser.uid).updateTotalBooks(totalBooks!);
    print(totalBooks);
  }

  countFavourites() async {
    QuerySnapshot _myDoc = await firestore
        .collection('books')
        .where('owner', isEqualTo: loggedInUser.email.toString())
        .where(
          'isFavourite',
          isEqualTo: true,
        ) //cannot use ==
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    totalFavourites = _myDocCount.length.toString();
    DatabaseServices(uid: loggedInUser.uid)
        .updateTotalFavourites(totalFavourites!);
    print(totalFavourites);
  }

  @override
  Widget build(BuildContext context) {
    Future pickAndUploadImage() async {
      final ImagePicker _picker = ImagePicker();
      try {
        XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
        print('Image Picking Process Starting');
        await new Future.delayed(const Duration(seconds: 2));
        if (image != null) {
          userProfilePicture = File(image.path);
          print(userProfilePicture);
          print(File(image.path));
          if (userProfilePicture.path != image.path) {
            print('It didnt work sorry');
            Navigator.pop(context);
          } else {
            print('Should be startting to put file in');
            var snapshot = await storage
                .ref()
                .child('userProfiles/$userEmail profile')
                .putFile(userProfilePicture);
            print('file put in!');
            profileURL = await snapshot.ref.getDownloadURL();
          }
        } else {
          print("Please choose a picture");
          return;
        }
        setState(() {
          DatabaseServices(uid: loggedInUser.uid).updateUserPhoto(profileURL!);
          print(profileURL);
        });
      } catch (e) {
        print(e);
      }
    }

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

    Container customCard(
        String displayText,
        IconData firstIcon,
        IconData secondIcon,
        double marginTop,
        Color mainIconColor,
        Color secondIconColor) {
      return Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: marginTop),
              height: 60,
              child: Card(
                shadowColor: Colors.black,
                elevation: 5,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Icon(
                        firstIcon,
                        color: mainIconColor,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        '$displayText',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 190),
                      child: Icon(
                        secondIcon,
                        size: 15,
                        color: secondIconColor,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'MY ACCOUNT',
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                        color: Colors.red,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                  final users = snapshot.data!.docs;
                  for (var user in users) {
                    var email = (user.data() as Map)['email'];
                    print('user email : $email');
                    countBooks();
                    countFavourites();
                    if (userEmail == email) {
                      profileURL = (user.data() as Map)['profileURL'];
                      userName = (user.data() as Map)['userName'];
                      age = (user.data() as Map)['age'];
                      totalBooks = (user.data() as Map)['totalBooks'];
                      totalFavourites = (user.data() as Map)['totalFavourites'];
                      currentLocation = (user.data() as Map)['location'];
                      about = (user.data() as Map)['about'];
                    }
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickAndUploadImage();
                        },
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                elevation: 10,
                                child: Container(
                                  width: 400,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                        color: Colors.purple, width: 5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: profileURL == ''
                                          ? NetworkImage(
                                              'https://www.brother.ca/resources/images/no-product-image.png')
                                          : NetworkImage(profileURL!),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 3, color: Colors.black),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: profileURL == ''
                                  ? NetworkImage(
                                      'https://www.brother.ca/resources/images/no-product-image.png')
                                  : NetworkImage(profileURL!),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          userEmail!,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                        ),
                      ),
                      customDivider(),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 200,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius:
                                  3, // how much spread does this shadow goes
                              blurRadius: 4, // how blurry the shadow is
                              offset:
                                  Offset(0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person,
                                  color: Colors.purple,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Username : $userName',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified_user,
                                    color: Colors.purple,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Age : $age',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_rounded,
                                    color: Colors.purple,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'Date Created : $createdDateDate / $createdDateMonth / $createdDateYear',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          height: 270,
                                          child: Column(
                                            children: [
                                              Container(
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: "$userName",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    userName = value;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: "$age",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    age = value;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                width: 300,
                                                height: 50,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          CupertinoAlertDialog(
                                                        title: Text(
                                                          "EDIT PROFILE",
                                                        ),
                                                        content: Text(
                                                            "Are you sure you want to edit the content of $userEmail ?"),
                                                        actions: [
                                                          CupertinoButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                          CupertinoButton(
                                                              child: Text(
                                                                'Edit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await DatabaseServices(uid: loggedInUser.uid).updateUserData(
                                                                      userName!,
                                                                      age!,
                                                                      userEmail!,
                                                                      profileURL!,
                                                                      totalBooks!,
                                                                      currentLocation!,
                                                                      about!,
                                                                      totalFavourites!);
                                                                  Navigator.pop(
                                                                      context);
                                                                } catch (e) {
                                                                  print(e
                                                                      .toString());
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "CONFIRM CHANGE",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings,
                                        color: Colors.purple,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Edit Profile',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Extra Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(
                            left: 20, right: 20, bottom: 20, top: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius:
                                  3, // how much spread does this shadow goes
                              blurRadius: 4, // how blurry the shadow is
                              offset:
                                  Offset(0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.purple,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Your Location : $currentLocation',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info,
                                    color: Colors.purple,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      'About You : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              about!,
                              style: TextStyle(
                                  wordSpacing: 2,
                                  letterSpacing: 1,
                                  height: 1.5),
                            ),
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        elevation: 5,
                                        child: Container(
                                          padding: EdgeInsets.all(20),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: Text(
                                                    'Location :',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showCountryPicker(
                                                    context: context,
                                                    onSelect:
                                                        (Country country) {
                                                      currentLocation =
                                                          country.name;
                                                      print(
                                                          'location : $currentLocation');
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  width: double.infinity,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2),
                                                    color: Colors.white,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 10),
                                                        child: Text(
                                                          '$currentLocation',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 20),
                                                        child: Icon(
                                                          Icons
                                                              .swap_horizontal_circle_sharp,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                child: TextFormField(
                                                  maxLines: null,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    labelText: "Edit About....",
                                                    labelStyle: TextStyle(
                                                        color: Colors.black),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                        width: 2.0,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                      borderSide: BorderSide(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  onChanged: (value) {
                                                    about = value;
                                                  },
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please enter some text';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                decoration: BoxDecoration(
                                                    color: Colors.purple,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                width: 300,
                                                height: 50,
                                                child: TextButton(
                                                  onPressed: () async {
                                                    showCupertinoDialog(
                                                      context: context,
                                                      builder: (_) =>
                                                          CupertinoAlertDialog(
                                                        title: Text(
                                                          "EDIT PROFILE",
                                                        ),
                                                        content: Text(
                                                            "Are you sure you want to edit the content of $userEmail ?"),
                                                        actions: [
                                                          CupertinoButton(
                                                              child: Text(
                                                                  'Cancel'),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              }),
                                                          CupertinoButton(
                                                              child: Text(
                                                                'Edit',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  await DatabaseServices(uid: loggedInUser.uid).updateUserData(
                                                                      userName!,
                                                                      age!,
                                                                      userEmail!,
                                                                      profileURL!,
                                                                      totalBooks!,
                                                                      currentLocation!,
                                                                      about!,
                                                                      totalFavourites!);
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                } catch (e) {
                                                                  print(e
                                                                      .toString());
                                                                }
                                                              }),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                    "CONFIRM CHANGE",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              customDivider(),
                                              Text(
                                                'Location will be updated once this pop-up is refreshed!',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.settings_accessibility,
                                        color: Colors.purple,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          'Edit Information',
                                          style:
                                              TextStyle(color: Colors.purple),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            'Content',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllBooksPage()),
                          );
                        },
                        child: customCard(
                            'My Books',
                            Icons.menu_book_rounded,
                            Icons.arrow_forward_ios_rounded,
                            10,
                            Colors.purple,
                            Colors.purple),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllFavouritesPage()),
                          );
                        },
                        child: customCard(
                            'Favourites',
                            Icons.favorite,
                            Icons.arrow_forward_ios_rounded,
                            0,
                            Colors.purple,
                            Colors.purple),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            'Statistic',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius:
                                  3, // how much spread does this shadow goes
                              blurRadius: 4, // how blurry the shadow is
                              offset:
                                  Offset(0, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.library_books_rounded,
                                  color: Colors.white,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Total Books : $totalBooks",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    child: Text(
                                      "Total Favorites : $totalFavourites",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      customDivider(),
                      Text(
                        '! No copyright !',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
