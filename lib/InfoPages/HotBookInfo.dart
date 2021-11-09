import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DecorationService.dart';
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
    makeColumnDetails(var getValue, String underText) {
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

    makeColumnDetailsSplitter() {
      return Container(
        width: 2,
        color: Colors.white,
        height: 30,
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: DecorationService.gradientColor(
            Alignment.bottomLeft,
            Alignment.topRight,
            Color(0xFF5614B0),
            Color(0xFFec2F4B),
            Color(0xFF7303c0),
            Color(0xFF1565C0),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  makeColumnDetails(bookID.bookPages, "pages"),
                  makeColumnDetailsSplitter(),
                  makeColumnDetails(bookID.bookLanguage, "language"),
                  makeColumnDetailsSplitter(),
                  makeColumnDetails(bookID.bookPublishedYear, "published"),
                ],
              ),
              UIServices.customDivider(Colors.white),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  bookID.bookDescription,
                  style: TextStyle(
                      wordSpacing: 2,
                      letterSpacing: 1,
                      color: Colors.white,
                      height: 1.5),
                ),
              ),
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
              return UIServices.showPopup(
                  "This book belongs to ${bookID.bookOwner}",
                  "assets/images/booksIcon.png",
                  false);
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
