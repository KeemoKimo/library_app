import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:intl/intl.dart';

import 'HomeScreenService.dart';

class BookInfoService {
  //! SHOW DELETE POPUP
  static showDeleteBookPopup(
      BuildContext context, var bookCollection, bookID, loggedInUser) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Do you want to delete this book?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content:
              Text("Books deleted cannot be recovered. Please think wisely."),
          actions: [
            HomeScreenService.makeCancelButton(context),
            BookInfoService.makeDeleteButton(
                bookCollection, bookID, loggedInUser, HomeScreen(), context),
          ],
        );
      },
    );
  }

  //! MAKE AUTHOR TEXT
  static showAuthorText(var bookID) {
    return Text(
      bookID.bookAuthor,
      style: TextStyle(
        fontSize: 15,
        color: Colors.black,
      ),
    );
  }

  //! MAKE CATEGORY TEXT
  static showCategoryText(var bookID) {
    return Text(
      bookID.bookCategory,
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //! MAKE BOOK START / FINISH DATE
  static showStartFinishDate(var bookID) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(CupertinoIcons.time_solid, color: Color(0xFF333399)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Start: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333399),
                  ),
                ),
                TextSpan(
                  text:
                      " ${bookID.bookStartDate.day} / ${bookID.bookStartDate.month} / ${bookID.bookStartDate.year}",
                ),
              ],
            ),
          ),
          BookInfoService.makeColumnDetailsSplitter(Color(0xFF333399)),
          Icon(CupertinoIcons.hourglass_bottomhalf_fill,
              color: Color(0xFF333399)),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: "Finish: ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333399),
                  ),
                ),
                TextSpan(
                  text:
                      " ${bookID.bookEndDate.day} / ${bookID.bookEndDate.month} / ${bookID.bookEndDate.year}",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //! SHOW BOOK COVER CONTAINER
  static showBookCoverContainer(var bookID) {
    return Container(
      margin: EdgeInsets.only(top: 50, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [UIServices.mainBoxShadow],
      ),
      width: 350,
      height: 550,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: Image.network(
          bookID.bookCover,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //! DETAILS FOR LANGUAGE, PAGE, YEAR OF THE BOOK
  static makeColumnDetails(var getValue, String underText, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          getValue,
          style: TextStyle(),
        ),
        UIServices.makeSpace(10),
        Text(
          underText,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  //! SEPERATE THE DETAILS
  static makeColumnDetailsSplitter(Color color) {
    return Container(
      width: 2,
      color: color,
      height: 40,
    );
  }

  //! USER NAVIGATE TO THE EDIT BOOKS PAGE
  static goToEditBookPage(
      String routeName, BuildContext context, var bookID) async {
    await Navigator.pushNamed(
      context,
      routeName,
      arguments: ScreenArguments(
        bookID.bookTitle,
        bookID.bookAuthor,
        bookID.bookCover,
        bookID.bookCategory,
        bookID.bookDescription,
        bookID.bookOwner,
        bookID.bookLanguage,
        bookID.bookPublishedYear,
        bookID.bookPages,
        bookID.bookStartDate,
        bookID.bookEndDate,
        bookID.isFavourite,
        bookID.bookId,
      ),
    );
  }

  //! MAKE THE ROW THAT CONTAIN LANGUAGE, PAGE, YEAR
  static makeDetailRow(var argument, bool isGreatPick) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BookInfoService.makeColumnDetails(argument.bookPages, "pages",
            isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399)),
        BookInfoService.makeColumnDetailsSplitter(
            isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399)),
        BookInfoService.makeColumnDetails(argument.bookLanguage, "language",
            isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399)),
        BookInfoService.makeColumnDetailsSplitter(
            isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399)),
        BookInfoService.makeColumnDetails(
            argument.bookPublishedYear,
            "published",
            isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399)),
      ],
    );
  }

//! WRITE BOOK DESCRIPTION
  static showDescription(var argument, bool isGreatPick) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          color: isGreatPick == true ? Color(0xFFFD4700) : Color(0xFF333399),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [UIServices.mainBoxShadow]),
      child: Text(
        argument.bookDescription,
        style: TextStyle(
            wordSpacing: 2, letterSpacing: 1, color: Colors.white, height: 1.8),
      ),
    );
  }

//! MAKE POPUP BUTTON FOR DELETE POPUP
  static makeDeleteButton(var bookCollection, argument, loggedInUser,
      destinationScreen, BuildContext context) {
    return UIServices.makePopUpButton(() async {
      await bookCollection.doc(argument.bookTitle + loggedInUser.uid).delete();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationScreen,
        ),
      );
      final snackBar = SnackBar(
        content: Text(
          'Your book has been deleted successfully!',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }, "Delete", Colors.red);
  }

//! TRIM DATE TIME
  static String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('dd-MM-yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }
}
