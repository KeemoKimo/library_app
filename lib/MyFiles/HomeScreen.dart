import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/ScreenService/HomeScreenService.dart';
import 'package:library_app/ScreenService/MyAccountService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/MyFiles/addBook.dart';
import 'package:library_app/categoryPages/SelectCategoryPage.dart';
import 'package:library_app/MyFiles/myAccount.dart';
import 'package:library_app/otherUserFiles/otherUserList.dart';
import 'package:library_app/variables.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late User loggedInUser;
  var auth = Variables.auth;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      Variables.firestore.collection('books').snapshots();
  late Stream<QuerySnapshot<Map<String, dynamic>>> userSnapshot =
      Variables.firestore.collection('users').snapshots();
  String totalBooks = '', totalFavourites = '';

//! FUNCTION WHEN THE SCREEN IS FIRED
  @override
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }

//! FUNCTION FOR GETTING THE LOGGED IN USER
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
    //! DRAWER (THE MENUS THAT SLIDES FROM THE LEFT SIDE)
    var drawer2 = Drawer(
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          children: [
            HomeScreenService.makeDrawerHeader(loggedInUser),
            HomeScreenService.buildListTile(
                CupertinoIcons.person_fill,
                Variables.themePurple,
                "My Account",
                MyAccountPage(
                  loggedInUser: loggedInUser,
                ),
                context),
            HomeScreenService.buildListTile(CupertinoIcons.group_solid,
                Variables.themePurple, 'Find People', OtherUserList(), context),
            HomeScreenService.buildListTile(
                Icons.list,
                Variables.themePurple,
                'Browse Categories',
                SelectCategoryPage(loggedInUser: loggedInUser),
                context),
            HomeScreenService.makeDivider,
            HomeScreenService.buildListTile(
                CupertinoIcons.book_fill,
                Colors.red,
                'All My Books',
                AllBooksPage(loggedInUser: loggedInUser),
                context),
            HomeScreenService.buildListTile(
                CupertinoIcons.heart_fill,
                Colors.red,
                'My Favourites',
                AllFavouritesPage(loggedInUser: loggedInUser),
                context),
            HomeScreenService.buildListTile(CupertinoIcons.add_circled_solid,
                Colors.red, 'Add Books', addBookPage(), context),
            HomeScreenService.makeDivider,
            HomeScreenService.buildListTile(
                Icons.info, Colors.black, 'About Us', AboutUs(), context),
            HomeScreenService.makeLogOutListTile(context, auth),
          ],
        ),
      ),
    );

    //! MAIN BODY FOR THE PAGE
    var mainBody = Scaffold(
      drawer: drawer2,
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot>(
          stream: bookSnapshot,
          builder: (context, snapshot) {
            //! CHECK IF THE USER RECIEVE DATA OR NOT
            if (!snapshot.hasData) {
              return HomeScreenService.loadingIndicator;
            }
            MyAccountService.countBooks(loggedInUser, totalBooks);
            MyAccountService.countFavourites(loggedInUser, totalFavourites);
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //! CONTAINER FOR MAIN PICTURE
                  HomeScreenService.mainPicture,
                  UIServices.customDivider(Colors.black),
                  //! LIST FOR HOT BOOKS
                  HomeScreenService.customTitle(
                      'EXCITING ',
                      "BOOKS 🔥🔥",
                      Alignment.centerLeft,
                      true,
                      false,
                      0xFFFF7400,
                      20,
                      true,
                      false),
                  UIServices.makeSpace(20),
                  HomeScreenService.verticalBookList(snapshot),
                  UIServices.customDivider(Variables.themeHotBookInfo),
                  //! LIST FOR ALL BOOKS
                  HomeScreenService.customTitle(
                      'YOUR ',
                      "BOOKS 📚",
                      Alignment.centerRight,
                      false,
                      true,
                      0xFF333399,
                      20,
                      false,
                      true),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 7, 2, false),
                  UIServices.makeSpace(20),
                  UIServices.customDivider(Variables.themeBookInfo),
                  //! LIST FOR ALL FAVOURITES
                  HomeScreenService.customTitle(
                      'YOUR ',
                      "FAVOURITES ❤️",
                      Alignment.centerLeft,
                      false,
                      true,
                      0xFFF44235,
                      20,
                      true,
                      false),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 7, 2, true),
                  UIServices.makeSpace(20),
                  UIServices.customDivider(Colors.red),
                  UIServices.makeSpace(10),
                  Text("Copyright ©"),
                  UIServices.makeSpace(30),
                ],
              ),
            );
          },
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: mainBody,
    );
  }
}
