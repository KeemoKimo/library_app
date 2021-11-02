import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/HomeScreen.dart';
import 'package:library_app/Services/UIServices.dart';

class OtherUserInfo extends StatefulWidget {
  const OtherUserInfo({Key? key}) : super(key: key);

  @override
  _OtherUserInfoState createState() => _OtherUserInfoState();
}

class _OtherUserInfoState extends State<OtherUserInfo> {
  late User loggedInUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> userSnapshot =
      firestore.collection('users').snapshots();
  late bool isFavouriteState;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  @override
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

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments as UserArguments;
    return Scaffold(
      backgroundColor: Color(0xFF331832),
      appBar: AppBar(
        title: Text(
          'USER DETAILS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF331832),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                GestureDetector(
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
                              border: Border.all(color: Colors.white, width: 5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: userID.userPFP == ''
                                    ? NetworkImage(
                                        'https://www.brother.ca/resources/images/no-product-image.png')
                                    : NetworkImage(userID.userPFP),
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
                      border: Border.all(width: 3, color: Colors.white),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: userID.userPFP == ''
                            ? NetworkImage(
                                'https://www.brother.ca/resources/images/no-product-image.png')
                            : NetworkImage(userID.userPFP),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    userID.userUserName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Text(
                    userID.email,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                ),
                UIServices.customDivider(Colors.white),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'More About ${userID.userUserName}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin:
                      EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF331832),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius:
                            3, // how much spread does this shadow goes
                        blurRadius: 4, // how blurry the shadow is
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        userID.userAbout,
                        style: TextStyle(
                            wordSpacing: 2,
                            letterSpacing: 1,
                            color: Colors.white,
                            height: 1.5),
                      ),
                      UIServices.customDivider(Colors.white),
                      Row(
                        children: [
                          Icon(
                            Icons.location_city,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: userID.isShowLocation == true
                                ? Text(
                                    "User Location : ${userID.userLocation}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                : Text(
                                    "Location Disclosed!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "Account Created (D/M/Y) : ${userID.userCreatedDate} / ${userID.userCreatedMonth} / ${userID.userCreatedYear}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.person_2,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: userID.isShowAge == true
                                ? Text(
                                    "User age : ${userID.age} years old",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  )
                                : Text(
                                    "User's age is private!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'Statistics',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF331832),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        spreadRadius:
                            3, // how much spread does this shadow goes
                        blurRadius: 4, // how blurry the shadow is
                        offset: Offset(0, 5), // changes position of shadow
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
                              "Total Books : ${userID.totalBooks}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              "Total Favourites : ${userID.userTotalFavourites}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                userID.isShowBook == true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'otherUserBooks',
                            arguments: UserArguments(
                              userID.age,
                              userID.email,
                              userID.userPFP,
                              userID.totalBooks,
                              userID.userUserName,
                              userID.userAbout,
                              userID.userTotalFavourites,
                              userID.userLocation,
                              userID.userCreatedDate,
                              userID.userCreatedMonth,
                              userID.userCreatedYear,
                              userID.isShowLocation,
                              userID.isShowAge,
                              userID.isShowBook,
                              userID.isShowFavourite,
                            ),
                          );
                          //print('${userID.email} all books!');
                        },
                        child: customCard(
                          'All Books',
                          Icons.menu_book_rounded,
                          Icons.arrow_forward_ios_rounded,
                          10,
                          Color(0xFF331832),
                          Color(0xFF331832),
                        ),
                      )
                    : SizedBox(
                        height: 30,
                      ),
                userID.isShowFavourite == true
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            'otherUserFavourites',
                            arguments: UserArguments(
                              userID.age,
                              userID.email,
                              userID.userPFP,
                              userID.totalBooks,
                              userID.userUserName,
                              userID.userAbout,
                              userID.userTotalFavourites,
                              userID.userLocation,
                              userID.userCreatedDate,
                              userID.userCreatedMonth,
                              userID.userCreatedYear,
                              userID.isShowLocation,
                              userID.isShowAge,
                              userID.isShowBook,
                              userID.isShowFavourite,
                            ),
                          );
                          //print('${userID.email} favourites books!');
                        },
                        child: customCard(
                          'All Favourite',
                          CupertinoIcons.star_circle_fill,
                          Icons.arrow_forward_ios_rounded,
                          10,
                          Color(0xFF331832),
                          Color(0xFF331832),
                        ),
                      )
                    : SizedBox(
                        height: 30,
                      ),
                UIServices.customDivider(Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
