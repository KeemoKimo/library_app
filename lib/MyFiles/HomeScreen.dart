import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/ScreenService/HomeScreenService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/MyFiles/addBook.dart';
import 'package:library_app/categoryPages/SelectCategoryPage.dart';
import 'package:library_app/MyFiles/myAccount.dart';
import 'package:library_app/otherUserFiles/otherUserList.dart';
import 'package:library_app/variables.dart';
import '../main.dart';

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
                Colors.green[800],
                "My Account",
                MyAccountPage(
                  loggedInUser: loggedInUser,
                ),
                context),
            HomeScreenService.buildListTile(CupertinoIcons.group_solid,
                Colors.green[800], 'Find People', OtherUserList(), context),
            HomeScreenService.buildListTile(
                Icons.list,
                Colors.green[800],
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
            ListTile(
              tileColor: Colors.red,
              leading: Icon(Icons.login_outlined, color: Colors.white),
              title: const Text(
                'Log Out',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Do you want to sign out?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      content:
                          Text("You are about to sign out of this account."),
                      actions: [
                        HomeScreenService.makeCancelButton(context),
                        HomeScreenService.makeSignOutButton(
                          context,
                          auth,
                          LoginPage(),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );

    //! MAIN BODY FOR THE PAGE
    var mainBody = Scaffold(
      drawer: drawer2,
      body: Container(
        decoration: HomeScreenService.bgGradient,
        child: StreamBuilder<QuerySnapshot>(
          stream: bookSnapshot,
          builder: (context, snapshot) {
            //! CHECK IF THE USER RECIEVE DATA OR NOT
            if (!snapshot.hasData) {
              return HomeScreenService.loadingIndicator;
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //! CONTAINER FOR MAIN PICTURE
                  HomeScreenService.mainPicture,
                  UIServices.customDivider(Colors.white),
                  //! LIST FOR HOT BOOKS
                  HomeScreenService.makeTitle('Hot Books ️‍🔥'),
                  UIServices.makeSpace(20),
                  HomeScreenService.verticalBookList(snapshot),
                  UIServices.customDivider(Colors.white),
                  //! LIST FOR ALL BOOKS
                  HomeScreenService.makeTitle('Your Collection 📚'),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 7, 2, false),
                  UIServices.makeSpace(20),
                  UIServices.customDivider(Colors.white),
                  //! LIST FOR ALL FAVOURITES
                  HomeScreenService.makeTitle('Favourites ❤️'),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 7, 2, true),
                  UIServices.makeSpace(20),
                  UIServices.customDivider(Colors.white),
                  UIServices.makeSpace(10),
                  HomeScreenService.makeTitle('Copyright ©'),
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
