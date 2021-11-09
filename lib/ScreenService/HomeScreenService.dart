import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DecorationService.dart';
import 'package:library_app/Services/UIServices.dart';

class HomeScreenService {
//! BUILD EACH TILE FOR THE APP DRAWER
  static buildListTile(IconData icon, Color? iconColor, String titleText,
      var goToPage, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        titleText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => goToPage,
          ),
        );
      },
    );
  }

//! POPUP BUTTON FOR SIGN OUT
  static makeCancelButton(BuildContext context) {
    return UIServices.makePopUpButton(() {
      Navigator.pop(context);
    }, "Cancel", Colors.blue);
  }

  static makeSignOutButton(BuildContext context, var auth, destinationPage) {
    return UIServices.makePopUpButton(() async {
      await auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationPage,
        ),
      );
    }, "Sign Out", Colors.red);
  }

//! MAIN SCREEN GRADIENT
  static var bgGradient = BoxDecoration(
    gradient: DecorationService.gradientColor(
      Alignment.bottomLeft,
      Alignment.topRight,
      Color(0xFF1a2a6c),
      Color(0xFF6f0000),
      Color(0xFF512DA8),
      Color(0xFF23074d),
    ),
  );

//! MAIN PICTURE FOR HOMESCREEN
  static var mainPicture = Container(
    width: double.infinity,
    height: 400,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/books.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 8,
          blurRadius: 8,
          offset: Offset(0, 7), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose what",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "to do today?",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );

//! MAKE TITE
  static makeTitle(String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }

//! MAKE HOT BOOKS SECTION
  static verticalBookList(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          String bookTitle = snapshot.data!.docs[index]['title'];
          String bookOwner = snapshot.data!.docs[index]['owner'];
          String bookCover = snapshot.data!.docs[index]['imageURL'];
          String bookCategory = snapshot.data!.docs[index]['category'];
          String bookAuthor = snapshot.data!.docs[index]['author'];
          String bookDescription = snapshot.data!.docs[index]['description'];
          String bookLanguage = snapshot.data!.docs[index]['language'];
          String bookPublished = snapshot.data!.docs[index]['publishedYear'];
          String bookPages = snapshot.data!.docs[index]['numberOfPages'];
          String bookStartDate = snapshot.data!.docs[index]['startDate'];
          String bookEndDate = snapshot.data!.docs[index]['endDate'];
          bool bookIsFavourite = snapshot.data!.docs[index]['isFavourite'];
          String bookId = snapshot.data!.docs[index]['bookId'];
          return Container(
            padding: EdgeInsets.all(20),
            width: 300,
            height: 300,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'HotBookInfo',
                  arguments: ScreenArguments(
                    bookTitle,
                    bookAuthor,
                    bookCover,
                    bookCategory,
                    bookDescription,
                    bookOwner,
                    bookLanguage,
                    bookPublished,
                    bookPages,
                    bookStartDate,
                    bookEndDate,
                    bookIsFavourite,
                    bookId,
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 230,
                    height: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(bookCover),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      bookTitle,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
