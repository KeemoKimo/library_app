import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';

import '../variables.dart';

class AllBookService {
  //! UPDATE THE FILTERING AND ALERTING THE USER WHEN THEY SWTICH FILTER MODE
  static changeFABFilter(var value, BuildContext context) {
    if (value == "title") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = SnackBar(
          backgroundColor: Variables.themeHotBookInfo,
          content: Text('Filtering by TITLE',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (value == "bookCategory") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = SnackBar(
          backgroundColor: Variables.themeHotBookInfo,
          content: Text('Filtering by CATEGORY',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (value == "bookAuthor") {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      final snackBar = SnackBar(
          backgroundColor: Variables.themeHotBookInfo,
          content: Text('Filtering by AUTHOR',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  //!(UI) MAKE FILTERING ITEM CONTAINER
  static makeFilterItemContainer(var icon, String displayLabel) {
    return Container(
      color: Variables.themeHotBookInfo,
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: Colors.white),
          Text(displayLabel, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  //!(SERVICE) CHECK SEARCH IF EXIST WITH FILTERING MODE
  static checkSearchResult(var sortByValue, allResult, controller, showResult) {
    if (sortByValue == "title") {
      for (var bookSnapshots in allResult) {
        var title = UIServices.fromSnapshot(bookSnapshots).title.toLowerCase();
        if (title.contains(controller.text.toLowerCase())) {
          showResult.add(bookSnapshots);
        }
      }
    } else if (sortByValue == "bookCategory") {
      for (var bookSnapshots in allResult) {
        var category =
            UIServices.fromSnapshot(bookSnapshots).bookCategory.toLowerCase();
        if (category.contains(controller.text.toLowerCase())) {
          showResult.add(bookSnapshots);
        }
      }
    } else if (sortByValue == "bookAuthor") {
      for (var bookSnapshots in allResult) {
        var author =
            UIServices.fromSnapshot(bookSnapshots).bookAuthor.toLowerCase();
        if (author.contains(controller.text.toLowerCase())) {
          showResult.add(bookSnapshots);
        }
      }
    }
  }
}
