import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:country_picker/country_picker.dart';
import '../Services/UIServices.dart';
import 'HomeScreen.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
  //! FUNCTION TO MAKE A CUSTOM CARD
  static Container customCard(
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
  bool _switchValueLocation = false;
  bool _switchValueAge = false;
  bool _switchValueBooks = false;
  bool _switchValueFavourite = false;
  var space40 = UIServices.makeSpace(40);
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              Color(0xFFb58ecc),
              Color(0xFF320D6D),
              Color(0xFF044B7F),
              Color(0xFFb91372),
            ],
          ),
        ),
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
                          backgroundColor: Colors.white,
                        ),
                      ),
                    );
                  }
                  final users = snapshot.data!.docs;
                  for (var user in users) {
                    var email = (user.data() as Map)['email'];
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
                      _switchValueLocation =
                          (user.data() as Map)['showLocation'];
                      _switchValueAge = (user.data() as Map)['showAge'];
                      _switchValueBooks = (user.data() as Map)['showBook'];
                      _switchValueFavourite =
                          (user.data() as Map)['showFavourite'];
                    }
                  }

                  return Column(
                    children: [
                      //! UPLOAD AND DISPLAY PFP
                      Container(
                        height: 450,
                        width: double.infinity,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Text(
                                    "My Profile",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
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
                                margin: EdgeInsets.only(top: 40),
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(width: 3, color: Colors.white),
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
                            UIServices.makeSpace(20),
                            Text(
                              userName!,
                              style: TextStyle(
                                fontSize: 23,
                                color: Colors.white,
                              ),
                            ),
                            UIServices.makeSpace(10),
                            Text(
                              userEmail!,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      //! EVERYTHING BELOW USER PROFILE
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            //!PROFILE SECTION
                            space40,
                            UIServices.customAlignedText(
                                Alignment.centerLeft, "Your Information"),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius:
                                        3, // how much spread does this shadow goes
                                    blurRadius: 4, // how blurry the shadow is
                                    offset: Offset(
                                        0, 5), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  makeRowItem(
                                      Icons.verified, "Age", age.toString()),
                                  space40,
                                  makeRowItem(
                                      Icons.calendar_today,
                                      "Created Date",
                                      "$createdDateDate / $createdDateMonth / $createdDateYear"),
                                  space40,
                                  makeRowItem(Icons.location_city, "Location",
                                      currentLocation.toString()),
                                  space40,
                                  makeRowItem(Icons.info, "About you", ""),
                                  UIServices.makeSpace(20),
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
                                        Navigator.pushNamed(
                                          context,
                                          'editProfile',
                                          arguments: UserArguments(
                                            age!,
                                            userEmail!,
                                            profileURL!,
                                            totalBooks!,
                                            userName!,
                                            about!,
                                            totalFavourites!,
                                            currentLocation!,
                                            createdDateDate!,
                                            createdDateMonth!,
                                            createdDateYear!,
                                            _switchValueLocation,
                                            _switchValueAge,
                                            _switchValueBooks,
                                            _switchValueFavourite,
                                          ),
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
                                                style: TextStyle(
                                                    color: Colors.purple),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
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
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.centerLeft,
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
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      child: TextFormField(
                                                        maxLines: null,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "Edit About....",
                                                          labelStyle: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.black,
                                                              width: 2.0,
                                                            ),
                                                          ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                            borderSide:
                                                                BorderSide(
                                                              color:
                                                                  Colors.blue,
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
                                                      margin: EdgeInsets.only(
                                                          top: 20),
                                                      decoration: BoxDecoration(
                                                          color: Colors.purple,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
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
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    }),
                                                                CupertinoButton(
                                                                    child: Text(
                                                                      'Edit',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      try {
                                                                        await DatabaseServices(uid: loggedInUser.uid)
                                                                            .updateUserData(
                                                                          userName!,
                                                                          age!,
                                                                          userEmail!,
                                                                          profileURL!,
                                                                          totalBooks!,
                                                                          currentLocation!,
                                                                          about!,
                                                                          totalFavourites!,
                                                                          createdDateDate!,
                                                                          createdDateMonth!,
                                                                          createdDateYear!,
                                                                          _switchValueLocation,
                                                                          _switchValueAge,
                                                                          _switchValueBooks,
                                                                          _switchValueFavourite,
                                                                        );
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
                                                        child: Row(
                                                          children: [
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 70,
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                "CHANGE",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        15),
                                                              ),
                                                            ),
                                                            Image(
                                                              image: AssetImage(
                                                                  'assets/images/confirm.png'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    UIServices.customDivider(
                                                        Colors.black),
                                                    Text(
                                                      'Location will be updated once this pop-up is refreshed!',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              Icons.settings,
                                              color: Colors.purple,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text(
                                                'Edit Information',
                                                style: TextStyle(
                                                    color: Colors.purple),
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
                            //!PRIVACY SETTINGS SECTION
                            UIServices.makeSpace(20),
                            UIServices.customAlignedText(
                                Alignment.centerLeft, "Privacy Settings"),
                            UIServices.makeSpace(20),
                            Column(
                              children: [
                                makeToggleContainer(
                                    context,
                                    'assets/images/location.png',
                                    'Show Location:',
                                    'Location',
                                    20,
                                    _switchValueLocation),
                                makeToggleContainer(
                                    context,
                                    'assets/images/age.png',
                                    'Show age:',
                                    'Age',
                                    50,
                                    _switchValueAge),
                                makeToggleContainer(
                                    context,
                                    'assets/images/booksIcon.png',
                                    'Show your books:',
                                    'Books',
                                    0,
                                    _switchValueBooks),
                                makeToggleContainer(
                                    context,
                                    'assets/images/heart.png',
                                    'Show Favourites:',
                                    'Favourites',
                                    3,
                                    _switchValueFavourite),
                              ],
                            ),
                            //!CONTENTS SECTION
                            UIServices.makeSpace(20),
                            UIServices.customAlignedText(
                                Alignment.centerLeft, "Contents"),
                            UIServices.makeSpace(20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllBooksPage()),
                                );
                              },
                              child: MyAccountPage.customCard(
                                'My Books',
                                Icons.menu_book_rounded,
                                Icons.arrow_forward_ios_rounded,
                                10,
                                Color(0xFFB03A2E),
                                Color(0xFFB03A2E),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AllFavouritesPage()),
                                );
                              },
                              child: MyAccountPage.customCard(
                                  'Favourites',
                                  Icons.favorite,
                                  Icons.arrow_forward_ios_rounded,
                                  0,
                                  Colors.red,
                                  Colors.red),
                            ),
                            UIServices.makeSpace(20),
                            //!STATISTICS SECTION
                            UIServices.makeSpace(20),
                            UIServices.customAlignedText(
                                Alignment.centerLeft, "Your Statistics"),
                            UIServices.makeSpace(20),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
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
                                    offset: Offset(
                                        0, 5), // changes position of shadow
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
                            UIServices.customDivider(Colors.black),
                            Text(
                              '! No copyright !',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
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

  //!FUNCTION TO MAKE THE ROW WIDGET WITH ICON AND TEXT
  Row makeRowItem(IconData icon, String leadingText, String trailingText) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.purple,
          size: 25,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '$leadingText : $trailingText',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
      ],
    );
  }

  //!FUNCTION FOR MAKING THE CONTAINER TO TOGGLE PRIVACY SETTINGS
  Container makeToggleContainer(
      BuildContext context,
      String imagePath,
      String instructionText,
      String details,
      double marginValue,
      bool switchValue) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3, // how much spread does this shadow goes
            blurRadius: 4, // how blurry the shadow is
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 40),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imagePath),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  instructionText,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Transform.scale(
                scale: 0.8,
                child: Container(
                  margin: EdgeInsets.only(left: marginValue),
                  child: CupertinoSwitch(
                    value: switchValue,
                    onChanged: (value) {
                      setState(
                        () {
                          switchValue = value;
                          print(switchValue);
                          if (details == "Location") {
                            DatabaseServices(uid: loggedInUser.uid)
                                .updateLocationPrivacyStatus(switchValue);
                          } else if (details == "Age") {
                            DatabaseServices(uid: loggedInUser.uid)
                                .updateAgePrivacyStatus(switchValue);
                          } else if (details == "Books") {
                            DatabaseServices(uid: loggedInUser.uid)
                                .updateBooksPrivacyStatus(switchValue);
                          } else if (details == "Favourites") {
                            DatabaseServices(uid: loggedInUser.uid)
                                .updateFavouritePrivacyStatus(switchValue);
                          }
                        },
                      );
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      var snackBar = SnackBar(
                        content: switchValue == true
                            ? Text('$details switched on!')
                            : Text('$details switched off!'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
