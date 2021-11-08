import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/MyFiles/addBook.dart';
import 'package:library_app/categoryPages/SelectCategoryPage.dart';
import 'package:library_app/MyFiles/myAccount.dart';
import 'package:library_app/otherUserFiles/otherUserList.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
  late Stream<QuerySnapshot<Map<String, dynamic>>> userSnapshot =
      firestore.collection('users').snapshots();

  buildListTile(
      IconData icon, Color? iconColor, String titleText, var goToPage) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        titleText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => goToPage,
          ),
        );
      },
    );
  }

  late Widget cancelBtn = TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: Text(
      "Cancel",
    ),
  );
  late Widget signOutBtn = TextButton(
    onPressed: () async {
      await auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    },
    child: Text(
      "Sign Out",
      style: TextStyle(
        color: Colors.red,
      ),
    ),
  );

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
    //! DRAWER (THE THING THAT SLIDES FROM THE LEFT SIDE)
    var drawer2 = Drawer(
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/bookBack.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 3, // how much spread does this shadow goes
                    blurRadius: 3, // how blurry the shadow is
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Text(
                          '${loggedInUser.email}',
                          style: TextStyle(
                            fontSize: 23,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          '${loggedInUser.email}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
            buildListTile(
              CupertinoIcons.person_fill,
              Colors.green[800],
              "My Account",
              MyAccountPage(
                loggedInUser: loggedInUser,
              ),
            ),
            buildListTile(
              CupertinoIcons.group_solid,
              Colors.green[800],
              'Find People',
              OtherUserList(),
            ),
            buildListTile(
              Icons.list,
              Colors.green[800],
              'Browse Categories',
              SelectCategoryPage(),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            buildListTile(
              CupertinoIcons.book_fill,
              Colors.red,
              'All My Books',
              AllBooksPage(),
            ),
            buildListTile(
              CupertinoIcons.heart_fill,
              Colors.red,
              'My Favourites',
              AllFavouritesPage(),
            ),
            buildListTile(
              CupertinoIcons.add_circled_solid,
              Colors.red,
              'Add Books',
              addBookPage(),
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            buildListTile(
              Icons.info,
              Colors.black,
              'About Us',
              AboutUs(),
            ),
            // Divider(
            //   height: 1,
            //   thickness: 1,
            //   color: Colors.black,
            // ),
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
                        cancelBtn,
                        signOutBtn,
                      ],
                    );
                  },
                );
                // await auth.signOut();
                // print("Signed Out successful");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );
              },
            ),
          ],
        ),
      ),
    );

    //! MAIN SCREEN
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: drawer2,
        body: StreamBuilder<QuerySnapshot>(
          stream: bookSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                    margin: EdgeInsets.only(top: 500),
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    )),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  //! CONTAINER FOR CATEGORIES
                  Container(
                    width: double.infinity,
                    height: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/books.jpg'),
                        fit: BoxFit.cover,
                        colorFilter:
                            ColorFilter.mode(Colors.grey, BlendMode.darken),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        colors: [
                          Color(0xFFc94b4b),
                          Color(0xFF8A2387),
                          Color(0xFFF27121),
                          Color(0xFF4b134f),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          spreadRadius: 8,
                          blurRadius: 8,
                          offset: Offset(0, 7), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Choose what",
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "to do today?",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  UIServices.customDivider(Colors.black),
                  //! LIST FOR ALL BOOKS
                  Text(
                    'Your Collection 📚',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Color(0xFFB03A2E),
                    ),
                  ),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 5, 2, false),
                  UIServices.makeSpace(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AllBooksPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFB03A2E),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            child: Image(
                              image: AssetImage('assets/images/allBooks.png'),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Text(
                              'View all your books!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIServices.customDivider(Colors.black),
                  //! LIST FOR ALL FAVOURITES
                  Text(
                    'Favourites ❤️',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.red,
                    ),
                  ),
                  UIServices.makeSpace(20),
                  UIServices.bookListViewBuilder(
                      snapshot, loggedInUser, 6, 3, true),
                  UIServices.makeSpace(20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllFavouritesPage()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            child: Text(
                              'See all your favourites!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            child: Icon(
                              Icons.favorite,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIServices.customDivider(Colors.black),
                  Text("Copyright"),
                  UIServices.makeSpace(20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
