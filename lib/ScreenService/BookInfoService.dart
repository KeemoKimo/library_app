import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:intl/intl.dart';

class BookInfoService {
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

  //! FUNCTION TO MAKE USER NAVIGATE TO THE EDIT BOOKS PAGE
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

  //!FUNCTION TO MAKE THE ROW THAT CONTAIN LANGUAGE, PAGE, YEAR
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
