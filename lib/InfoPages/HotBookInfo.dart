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
        decoration: BookInfoService.bgGradient,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //! BOOK COVER
              Container(
                margin: EdgeInsets.only(top: 50),
                decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 2), // changes position of shadow
                    ),
                  ],
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
              UIServices.makeSpace(10),
              //! TITLE , CATEGORY , AUTHOR
              Text(
                bookID.bookTitle,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              UIServices.makeSpace(10),
              Text(
                bookID.bookCategory,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              UIServices.makeSpace(10),
              Text(
                bookID.bookAuthor,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              UIServices.makeSpace(30),
              //! LANGUAGE , PAGES , YEAR
              BookInfoService.makeDetailRow(bookID),
              UIServices.customDivider(Colors.white),
              //! BOOK DESCRIPTION
              BookInfoService.showDescription(bookID),
              UIServices.customDivider(Colors.white),
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
                  "Book Ownership",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: Text("This book belongs to : ${bookID.bookOwner}"),
              );
            },
          );
        },
        backgroundColor: Color(0xFF5D14C0),
        child: Icon(
          Icons.info,
        ),
      ),
    );
  }
}
