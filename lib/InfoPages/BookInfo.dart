import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //! BOOK COVER
              BookInfoService.showBookCoverContainer(bookID),
              //! TITLE & TOGGLE FAVOURITE
              Wrap(
                alignment: WrapAlignment.center,
                direction: Axis.horizontal,
                spacing: 8.0,
                runSpacing: 20.0,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      bookID.bookTitle,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333399),
                      ),
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
              BookInfoService.showCategoryText(bookID),
              UIServices.makeSpace(10),
              BookInfoService.showAuthorText(bookID),
              UIServices.makeSpace(30),
              //! LANGUAGE , PAGES , YEAR
              BookInfoService.makeDetailRow(bookID, false),
              UIServices.customDivider(Variables.themeBookInfo),
              BookInfoService.showStartFinishDate(bookID),
              UIServices.customDivider(Variables.themeBookInfo),
              //! BOOK DESCRIPTION
              BookInfoService.showDescription(bookID, false),
              UIServices.customDivider(Variables.themeBookInfo),
            ],
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 10,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        backgroundColor: Variables.themeBookInfo,
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
            backgroundColor: Variables.themeBookInfo,
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
              BookInfoService.showDeleteBookPopup(
                  context, bookCollection, bookID, loggedInUser);
            },
          ),
        ],
      ),
    );
  }
}
