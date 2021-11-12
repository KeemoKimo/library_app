import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class MyAccountService {
  //! MY PROFILE LABEL
  static var myProfileLabel = Text(
    "My Profile",
    style: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );

  //! USER INFORMATION DECORATION
  static var infoContainerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      topLeft: Radius.circular(20),
    ),
    boxShadow: [UIServices.mainBoxShadow],
  );

  //! ADD A PHOTO ICON
  static var add_a_photo_icon = Container(
    margin: EdgeInsets.only(top: 200, right: 10),
    alignment: Alignment.bottomRight,
    child: Icon(
      Icons.add_a_photo,
      color: Colors.white,
      size: 30,
    ),
  );

  //! USERNAME TEXT
  static showUsernameText(String userName) {
    return Text(
      userName,
      style: TextStyle(
        fontSize: 23,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

//! EMAIL TEXT
  static showEmailText(String userEmail) {
    return Text(
      userEmail,
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }

  //! MY ACCOUNT SHOW PROFILE PICTURE CONTAINER (CIRCLE)
  static showMyProfilePicRoundedContainer(String profileURL) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(width: 3, color: Colors.white),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: profileURL == ''
              ? NetworkImage(
                  'https://www.brother.ca/resources/images/no-product-image.png')
              : NetworkImage(profileURL),
        ),
      ),
    );
  }

//! SHOW USER PROFILE PICTURE WHEN USER HOLD
  static showProfilePicturePopup(BuildContext context, String profileURL) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 10,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              boxShadow: [UIServices.mainBoxShadow],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: profileURL == ''
                    ? NetworkImage(
                        'https://www.brother.ca/resources/images/no-product-image.png')
                    : NetworkImage(profileURL),
              ),
            ),
          ),
        );
      },
    );
  }

  //! COUNT ALL BOOKS FOR THIS USER
  static countBooks(var loggedInUser, totalBooks) async {
    QuerySnapshot _myDoc = await Variables.firestore
        .collection('books')
        .where('owner',
            isEqualTo: loggedInUser.email.toString()) //cannot use ==
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    totalBooks = _myDocCount.length.toString();
    DatabaseServices(uid: loggedInUser.uid).updateTotalBooks(totalBooks!);
  }

//! COUNT ALL FAVOURITE BOOKS FOR THIS USER
  static countFavourites(var loggedInUser, totalFavourites) async {
    QuerySnapshot _myDoc = await Variables.firestore
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

//! YOUR INFORMATION SECTION
  static makeYourInfo(var space, age, createdDateDate, createdDateMonth,
      createdDateYear, about, currentLocation) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
        color: Color(0xFF4D028A),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [UIServices.mainBoxShadow],
      ),
      child: Column(
        children: [
          UIServices.makeSpace(20),
          UIServices.makeRowItem(
              CupertinoIcons.person_fill, "Age", age.toString(), Colors.white),
          space,
          UIServices.makeRowItem(
              CupertinoIcons.calendar,
              "Created Date",
              "$createdDateDate / $createdDateMonth / $createdDateYear",
              Colors.white),
          space,
          UIServices.makeRowItem(Icons.pin_drop, "Location",
              currentLocation.toString(), Colors.white),
          UIServices.makeSpace(10),
          UIServices.customDivider(Colors.white),
          UIServices.makeSpace(10),
          UIServices.makeRowItem(Icons.info, "About you", "", Colors.white),
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
          UIServices.makeSpace(20),
        ],
      ),
    );
  }

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
        color: Color(0xFF4D028A),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [UIServices.mainBoxShadow],
      ),
      child: Container(
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
      ),
    );
  }

//! CONTENTS SECTION
  static makeBooksContents(
      BuildContext context, var desitnationPage, firstIcon, secondIcon, text) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => desitnationPage),
        );
      },
      child: customCard(
        text,
        firstIcon,
        secondIcon,
        0,
        Colors.white,
        Colors.white,
      ),
    );
  }

//! YOUR STATISTICS SECTION
  static makeYourStatistic(var totalBooks, totalFavourites) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFF4D028A),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [UIServices.mainBoxShadow],
      ),
      child: Column(
        children: [
          UIServices.makeRowItem(
              Icons.book, "Total Books", totalBooks!, Colors.white),
          UIServices.makeSpace(40),
          UIServices.makeRowItem(Icons.favorite, "Total Favourites",
              totalFavourites!, Colors.white),
        ],
      ),
    );
  }
}
