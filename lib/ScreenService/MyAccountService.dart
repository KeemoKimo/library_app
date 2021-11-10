import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/DecorationService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class MyAccountService {
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

//! ABOUT ME TEXTBOX (EDIT PROFILE)
  static makeAboutMeTextbox(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xFF4D028A),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 15,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
          labelText: "About me",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

//! CUSTOM ALIGN TEXT (EDIT PROFILE)
  static makeCustomAlignedText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Color(0xFF4D028A),
        ),
      ),
    );
  }
}
