import 'package:flutter/material.dart';
import 'package:library_app/ScreenService/BookInfoService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

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
              Container(
                margin: EdgeInsets.only(top: 50),
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
              ),
              UIServices.makeSpace(20),
              //! TITLE , CATEGORY , AUTHOR
              Text(
                "🔥 ${bookID.bookTitle} 🔥",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFD4700)),
              ),
              UIServices.makeSpace(10),
              Text(bookID.bookCategory,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              UIServices.makeSpace(10),
              Text(
                bookID.bookAuthor,
                style: TextStyle(fontSize: 15, color: Colors.black),
              ),
              UIServices.makeSpace(30),
              //! LANGUAGE , PAGES , YEAR
              BookInfoService.makeDetailRow(bookID, true),
              UIServices.customDivider(Color(0xFFFD4700)),
              //! BOOK DESCRIPTION
              BookInfoService.showDescription(bookID, true),
              UIServices.customDivider(Color(0xFFFD4700)),
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
