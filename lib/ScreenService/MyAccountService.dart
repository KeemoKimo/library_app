import 'package:cloud_firestore/cloud_firestore.dart';
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

//! MAIN BACKGROUND
  static var bgGradient = BoxDecoration(
    gradient: DecorationService.gradientColor(
      Alignment.bottomLeft,
      Alignment.topRight,
      Color(0xFFb58ecc),
      Color(0xFF320D6D),
      Color(0xFF044B7F),
      Color(0xFFb91372),
    ),
  );

//! YOUR INFORMATION BACKGROUND
  static var yourInformationBg = DecorationService.gradientColor(
    Alignment.bottomLeft,
    Alignment.topRight,
    Color(0xFF7303c0),
    Color(0xFF93291E),
    Color(0xFF044B7F),
    Color(0xFFb91372),
  );

//! YOUR INFORMATION SECTION
  static makeYourInfo(var space, age, createdDateDate, createdDateMonth,
      createdDateYear, about, currentLocation) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 20),
      decoration: BoxDecoration(
        gradient: MyAccountService.yourInformationBg,
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
          UIServices.makeRowItem(
              Icons.verified, "Age", age.toString(), Colors.white),
          space,
          UIServices.makeRowItem(
              Icons.calendar_today,
              "Created Date",
              "$createdDateDate / $createdDateMonth / $createdDateYear",
              Colors.white),
          space,
          UIServices.makeRowItem(Icons.location_city, "Location",
              currentLocation.toString(), Colors.white),
          space,
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

//! CONTENTS SECTION
  static makeMyBooksContents(BuildContext context, var desitnationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => desitnationPage),
        );
      },
      child: customCard(
        'My Books',
        Icons.menu_book_rounded,
        Icons.arrow_forward_ios_rounded,
        0,
        Colors.white,
        Colors.white,
      ),
    );
  }

  static makeMyFavouritesContent(BuildContext context, var desitnationPage) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => desitnationPage),
        );
      },
      child: customCard('Favourites', Icons.favorite,
          Icons.arrow_forward_ios_rounded, 0, Colors.white, Colors.white),
    );
  }

//! YOUR STATISTICS SECTION
  static makeYourStatistic(var totalBooks, totalFavourites) {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: DecorationService.gradientColor(
          Alignment.bottomRight,
          Alignment.topLeft,
          Color(0xFFb58ecc),
          Color(0xFF320D6D),
          Color(0xFF044B7F),
          Color(0xFF93291E),
        ),
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
