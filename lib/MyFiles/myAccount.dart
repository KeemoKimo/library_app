import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import '../Services/UIServices.dart';

class MyAccountPage extends StatefulWidget {
  final User loggedInUser;
  const MyAccountPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _MyAccountPageState createState() =>
      _MyAccountPageState(loggedInUser: loggedInUser);
  //! FUNCTION TO MAKE A CUSTOM CARD
  static Container customCard(
    String displayText,
    IconData firstIcon,
    IconData secondIcon,
    double marginTop,
    Color mainIconColor,
    Color secondIconColor,
  ) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFc31432),
            Color(0xFF320D6D),
            Color(0xFF044B7F),
            Color(0xFF240b36),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: marginTop),
            height: 60,
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
                      color: mainIconColor,
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
          )
        ],
      ),
    );
  }
}

class _MyAccountPageState extends State<MyAccountPage> {
  late User loggedInUser;
  _MyAccountPageState({required this.loggedInUser});
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late File userProfilePicture;
  late String? userEmail = loggedInUser.email, userUID = loggedInUser.uid;
  late String? profileURL = '',
      userName = '',
      age = '',
      totalBooks = '',
      totalFavourites = '',
      currentLocation = '',
      about = '';
  late int? createdDateYear = loggedInUser.metadata.creationTime!.year,
      createdDateMonth = loggedInUser.metadata.creationTime!.month,
      createdDateDate = loggedInUser.metadata.creationTime!.day;
  bool _switchValueLocation = false,
      _switchValueAge = false,
      _switchValueBooks = false,
      _switchValueFavourite = false;
  var space40 = UIServices.makeSpace(40);
  void initState() {
    super.initState();
    build(context);
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

    print(loggedInUser.email);
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
                                  child: Hero(
                                    tag: 'EditPage',
                                    child: Material(
                                      type: MaterialType.transparency,
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
                                        child: Icon(
                                          Icons.settings,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 200,
                              child: Stack(
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
                                                image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: profileURL == ''
                                                      ? NetworkImage(
                                                          'https://www.brother.ca/resources/images/no-product-image.png')
                                                      : NetworkImage(
                                                          profileURL!),
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
                                        border: Border.all(
                                            width: 3, color: Colors.white),
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
                                    margin:
                                        EdgeInsets.only(top: 200, right: 10),
                                    alignment: Alignment.bottomRight,
                                    child: Icon(
                                      Icons.add_a_photo,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  )
                                ],
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
                            //!YOUR INFORMATION SECTION
                            space40,
                            UIServices.customAlignedText(Alignment.centerLeft,
                                "Your Information", Colors.black),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20),
                              margin: EdgeInsets.only(
                                  top: 20, left: 10, right: 10, bottom: 20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xFF7303c0),
                                    Color(0xFF93291E),
                                    Color(0xFF044B7F),
                                    Color(0xFFb91372),
                                  ],
                                ),
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
                                  UIServices.makeRowItem(Icons.verified, "Age",
                                      age.toString(), Colors.white),
                                  space40,
                                  UIServices.makeRowItem(
                                      Icons.calendar_today,
                                      "Created Date",
                                      "$createdDateDate / $createdDateMonth / $createdDateYear",
                                      Colors.white),
                                  space40,
                                  UIServices.makeRowItem(
                                      Icons.location_city,
                                      "Location",
                                      currentLocation.toString(),
                                      Colors.white),
                                  space40,
                                  UIServices.makeRowItem(Icons.info,
                                      "About you", "", Colors.white),
                                  UIServices.makeSpace(20),
                                  Text(
                                    about!,
                                    style: TextStyle(
                                      wordSpacing: 2,
                                      letterSpacing: 1,
                                      height: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //!PRIVACY SETTINGS SECTION
                            UIServices.makeSpace(20),
                            UIServices.customAlignedText(Alignment.centerLeft,
                                "Privacy Settings", Colors.black),
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
                                Alignment.centerLeft, "Contents", Colors.black),
                            UIServices.makeSpace(20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllBooksPage(
                                            loggedInUser: loggedInUser,
                                          )),
                                );
                              },
                              child: MyAccountPage.customCard(
                                'My Books',
                                Icons.menu_book_rounded,
                                Icons.arrow_forward_ios_rounded,
                                10,
                                Colors.white,
                                Colors.white,
                              ),
                            ),
                            UIServices.makeSpace(20),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllFavouritesPage(
                                            loggedInUser: loggedInUser,
                                          )),
                                );
                              },
                              child: MyAccountPage.customCard(
                                  'Favourites',
                                  Icons.favorite,
                                  Icons.arrow_forward_ios_rounded,
                                  0,
                                  Colors.white,
                                  Colors.white),
                            ),
                            UIServices.makeSpace(20),
                            //!STATISTICS SECTION
                            UIServices.makeSpace(20),
                            UIServices.customAlignedText(Alignment.centerLeft,
                                "Your Statistics", Colors.black),
                            UIServices.makeSpace(20),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 20, right: 20),
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topLeft,
                                  colors: [
                                    Color(0xFFb58ecc),
                                    Color(0xFF320D6D),
                                    Color(0xFF044B7F),
                                    Color(0xFF93291E),
                                  ],
                                ),
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
                                  UIServices.makeRowItem(Icons.book,
                                      "Total Books", totalBooks!, Colors.white),
                                  UIServices.makeSpace(40),
                                  UIServices.makeRowItem(
                                      Icons.favorite,
                                      "Total Favourites",
                                      totalFavourites!,
                                      Colors.white),
                                ],
                              ),
                            ),
                            //!ENDING
                            UIServices.customDivider(Colors.black),
                            Text(
                              '! No copyright !',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            UIServices.makeSpace(20),
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
