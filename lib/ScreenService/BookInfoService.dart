import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DecorationService.dart';
import 'package:library_app/Services/UIServices.dart';

class BookInfoService {
  //! DETAILS FOR LANGUAGE, PAGE, YEAR OF THE BOOK
  static makeColumnDetails(var getValue, String underText) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          getValue,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        UIServices.makeSpace(10),
        Text(
          underText,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  //! SEPERATE THE DETAILS
  static makeColumnDetailsSplitter() {
    return Container(
      width: 2,
      color: Colors.white,
      height: 30,
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
  static makeDetailRow(var argument) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        BookInfoService.makeColumnDetails(argument.bookPages, "pages"),
        BookInfoService.makeColumnDetailsSplitter(),
        BookInfoService.makeColumnDetails(argument.bookLanguage, "language"),
        BookInfoService.makeColumnDetailsSplitter(),
        BookInfoService.makeColumnDetails(
            argument.bookPublishedYear, "published"),
      ],
    );
  }

  //! BACKGROUND GRADIENT
  static var bgGradient = BoxDecoration(
    gradient: DecorationService.gradientColor(
      Alignment.bottomLeft,
      Alignment.topRight,
      Color(0xFF5614B0),
      Color(0xFFec2F4B),
      Color(0xFF7303c0),
      Color(0xFF1565C0),
    ),
  );

//! WRITE BOOK DESCRIPTION
  static showDescription(var argument) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        argument.bookDescription,
        style: TextStyle(
            wordSpacing: 2, letterSpacing: 1, color: Colors.white, height: 1.5),
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
}
