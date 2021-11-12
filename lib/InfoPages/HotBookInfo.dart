import 'package:flutter/material.dart';
import 'package:library_app/ScreenService/BookInfoService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class HotBooksInfo extends StatefulWidget {
  const HotBooksInfo({Key? key}) : super(key: key);

  @override
  _HotBooksInfoState createState() => _HotBooksInfoState();
}

class _HotBooksInfoState extends State<HotBooksInfo> {
  @override
  Widget build(BuildContext context) {
    final bookID =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //! BOOK COVER
              BookInfoService.showBookCoverContainer(bookID),
              UIServices.makeSpace(20),
              //! TITLE , CATEGORY , AUTHOR
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  "🔥 ${bookID.bookTitle} 🔥",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Variables.themeHotBookInfo),
                ),
              ),
              UIServices.makeSpace(10),
              BookInfoService.showCategoryText(bookID),
              UIServices.makeSpace(10),
              BookInfoService.showAuthorText(bookID),
              UIServices.makeSpace(30),
              //! LANGUAGE , PAGES , YEAR
              BookInfoService.makeDetailRow(bookID, true),
              UIServices.customDivider(Variables.themeHotBookInfo),
              //! BOOK DESCRIPTION
              BookInfoService.showDescription(bookID, true),
              UIServices.customDivider(Variables.themeHotBookInfo),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "🔥 Book Ownership",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xFFFD4700)),
                ),
                content: Text(bookID.bookOwner),
              );
            },
          );
        },
        backgroundColor: Color(0xFFFD4700),
        child: Icon(
          Icons.info,
        ),
      ),
    );
  }
}
