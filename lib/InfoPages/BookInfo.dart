import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/ScreenService/BookInfoService.dart';
import 'package:library_app/ScreenService/HomeScreenService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class BookInfo extends StatefulWidget {
  const BookInfo({Key? key}) : super(key: key);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  late User loggedInUser;
  var auth = Variables.auth;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      Variables.firestore.collection('books').snapshots();
  late bool isFavouriteState;
  CollectionReference bookCollection =
      FirebaseFirestore.instance.collection('books');
  @override
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }

  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

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
                margin: EdgeInsets.only(top: 50, bottom: 20),
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
              //! TITLE & TOGGLE FAVOURITE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      bookID.bookTitle,
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  StreamBuilder(
                    stream: bookSnapshot,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                      return (bookID.isFavourite == false)
                          ? GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    isFavouriteState = true;
                                    DatabaseServices(uid: loggedInUser.uid)
                                        .updateFavouriteStatus(isFavouriteState,
                                            bookID.bookTitle, loggedInUser.uid);
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    var snackBar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                        'Added to favourites',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.favorite_border_outlined,
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(
                                  () {
                                    isFavouriteState = false;
                                    DatabaseServices(uid: loggedInUser.uid)
                                        .updateFavouriteStatus(isFavouriteState,
                                            bookID.bookTitle, loggedInUser.uid);
                                    var snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Removed from favourites',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            );
                    },
                  ),
                ],
              ),
              UIServices.makeSpace(10),
              //! CATEGORY AND AUTHOR
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 10,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        backgroundColor: Color(0xFF3246C0),
        children: [
          SpeedDialChild(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            child: Icon(Icons.photo),
            label: "Edit Cover",
            onTap: () {
              BookInfoService.goToEditBookPage(
                  'editBookCover', context, bookID);
            },
          ),
          SpeedDialChild(
            backgroundColor: Color(0xFFC9226D),
            foregroundColor: Colors.white,
            child: Icon(Icons.settings),
            label: "Edit Information",
            onTap: () {
              BookInfoService.goToEditBookPage('editBookInfo', context, bookID);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: Icon(Icons.delete),
            label: "Delete Book",
            onTap: () {
              showDialog(
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
                    content: Text(
                        "Books deleted cannot be recovered. Please think wisely."),
                    actions: [
                      HomeScreenService.makeCancelButton(context),
                      BookInfoService.makeDeleteButton(bookCollection, bookID,
                          loggedInUser, HomeScreen(), context),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
