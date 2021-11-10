//! THE CLASS TO PASS ALL OF THE BOOKS (CLICKED) INFO TO ANOTHER SCREEN
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScreenArguments {
  late final String bookTitle;
  late final String bookAuthor;
  late final String bookCover;
  late final String bookCategory;
  late final String bookDescription;
  late final String bookOwner;
  late final String bookLanguage;
  late final String bookPublishedYear;
  late final String bookPages;
  late final DateTime bookStartDate;
  late final DateTime bookEndDate;
  late final bool isFavourite;
  late final String bookId;

  ScreenArguments(
    this.bookTitle,
    this.bookAuthor,
    this.bookCover,
    this.bookCategory,
    this.bookDescription,
    this.bookOwner,
    this.bookLanguage,
    this.bookPublishedYear,
    this.bookPages,
    this.bookStartDate,
    this.bookEndDate,
    this.isFavourite,
    this.bookId,
  );
}

//! THE CLASS TO PASS ALL OF THE  LOGGED IN USER (CLICKED) INFO TO ANOTHER SCREEN
class UserArguments {
  late final String age;
  late final String email;
  late final String userPFP;
  late final String totalBooks;
  late final String userUserName;
  late final String userAbout;
  late final String userTotalFavourites;
  late final String userLocation;
  late final int userCreatedDate;
  late final int userCreatedMonth;
  late final int userCreatedYear;
  late final bool isShowLocation;
  late final bool isShowAge;
  late final bool isShowBook;
  late final bool isShowFavourite;
  late final userEmail;

  UserArguments(
    this.age,
    this.email,
    this.userPFP,
    this.totalBooks,
    this.userUserName,
    this.userAbout,
    this.userTotalFavourites,
    this.userLocation,
    this.userCreatedDate,
    this.userCreatedMonth,
    this.userCreatedYear,
    this.isShowLocation,
    this.isShowAge,
    this.isShowBook,
    this.isShowFavourite,
  );

  UserArguments.fromSnapshot(DocumentSnapshot snapshot) {
    userUserName = snapshot['userName'];
    userPFP = snapshot['profileURL'];
    userEmail = snapshot['email'];
    totalBooks = snapshot['totalBooks'];
    userTotalFavourites = snapshot['totalFavourites'];
    age = snapshot['age'];
    userAbout = snapshot['about'];
    userLocation = snapshot['location'];
    userCreatedDate = snapshot['createdDate'];
    userCreatedMonth = snapshot['createdMonth'];
    userCreatedYear = snapshot['createdYear'];
    isShowLocation = snapshot['showLocation'];
    isShowAge = snapshot['showAge'];
    isShowBook = snapshot['showBook'];
    isShowFavourite = snapshot['showFavourite'];
  }

  //!MAKE A USER CARD
  static makeUserListTiles(
    String userPfp,
    userUserName,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.all(20),
      leading: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(50),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(userPfp),
          ),
        ),
      ),
      title: Text(
        userUserName.toString(),
        style: TextStyle(
          fontSize: 17,
        ),
      ),
    );
  }
}
