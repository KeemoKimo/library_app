import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/categoryPages/biography.dart';
import 'package:library_app/categoryPages/comic.dart';
import 'package:library_app/categoryPages/design.dart';
import 'package:library_app/categoryPages/fiction.dart';
import 'package:library_app/categoryPages/historical.dart';
import 'package:library_app/categoryPages/non_fiction.dart';
import 'package:library_app/categoryPages/philosophy.dart';
import 'package:library_app/categoryPages/sci_fi.dart';
import 'package:library_app/main.dart';
import 'dart:math' as math;
import 'package:library_app/myAccount.dart';

import 'InfoPages/aboutUs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String? userUID = loggedInUser.uid;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
  late Stream<QuerySnapshot<Map<String, dynamic>>> userSnapshot =
      firestore.collection('users').snapshots();
  late int? createdDateYear = loggedInUser.metadata.creationTime!.year;
  late int? createdDateMonth = loggedInUser.metadata.creationTime!.month;
  late int? createdDateDate = loggedInUser.metadata.creationTime!.day;
  //====================================================================
  late int? lastSignInDate = loggedInUser.metadata.lastSignInTime!.day;
  late int? lastSignInHour = loggedInUser.metadata.lastSignInTime!.hour;
  late int? lastSignInMinute = loggedInUser.metadata.lastSignInTime!.minute;
  late int? lastSignInMonth = loggedInUser.metadata.lastSignInTime!.month;
  late int? lastSignInYear = loggedInUser.metadata.lastSignInTime!.year;
  //====================================================================
  // late List<Widget> bookTitles = [];
  // late List<Widget> bookCovers = [];
  // late List<Widget> bookAuthors = [];

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

  Container customDivider() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.black,
      ),
    );
  }

  Container customSmallContainer(String imagePath, String description) {
    return Container(
      margin: EdgeInsets.only(right: 20, left: 20),
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.7),
            spreadRadius: 4, // how much spread does this shadow goes
            blurRadius: 4, // how blurry the shadow is
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              image: DecorationImage(
                  image: AssetImage('$imagePath'), fit: BoxFit.cover),
            ),
            height: 130,
          ),
          Container(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              '$description',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Card buildListTile(
    final String bookCoverURL,
    final String category,
    final String title,
    final String author,
  ) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(bookCoverURL)),
                ),
              ),
              Container(
                width: 230,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      category.toString(),
                      style: TextStyle(
                        color: Color(0xFFB03A2E),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        title.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        (author),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15,
              )
            ],
          ),
        ],
      ),
      //color: Colors.yellowAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 10,
      margin: EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            ListTile(
              leading:
                  Icon(CupertinoIcons.person_fill, color: Colors.green[800]),
              title: const Text(
                'My Account',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.add_circled_solid,
                color: Color(0xFF0CCE6B),
              ),
              title: const Text(
                'Add Books',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addBookPage()),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                CupertinoIcons.book_fill,
                color: Colors.deepOrange,
              ),
              title: const Text(
                'All My Books',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllBooksPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(CupertinoIcons.heart_fill, color: Colors.red),
              title: const Text(
                'My Favourites',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllFavouritesPage()),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(
                Icons.help,
                color: Colors.yellow[800],
              ),
              title: const Text(
                'Help',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                print('Help Pressed');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: Color(0xFFA50104),
              ),
              title: const Text(
                'About Us',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutUs()),
                );
              },
            ),
            // Divider(
            //   height: 1,
            //   thickness: 1,
            //   color: Colors.black,
            // ),
            ListTile(
              tileColor: Colors.red,
              leading: Icon(Icons.logout_outlined, color: Colors.white),
              title: const Text(
                'Log Out',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text("LOG OUT"),
                    content: Text(
                        "Are you sure you want to log out of ${loggedInUser.email} ?"),
                    actions: [
                      CupertinoButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      CupertinoButton(
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            await auth.signOut();
                            print('Sign out succesful');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }),
                    ],
                  ),
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

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: drawer2,
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: bookSnapshot,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                            color: Colors.red,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            )),
                      );
                    }
                    // final books = snapshot.data!.docs;

                    // List<Widget> bookWidgets = [];
                    // for (var book in books) {
                    //   title = (book.data() as Map)['title'];
                    //   var author = (book.data() as Map)['author'];
                    //   owner = (book.data() as Map)['owner'];
                    //   var bookCoverURL = (book.data() as Map)['imageURL'];
                    //   var category = (book.data() as Map)['category'];

                    //   if (owner == userEmail) {
                    //     print(owner! + ' IS THE OWNER!');
                    //     final bookWidget = Books(
                    //       bookCoverURL: bookCoverURL,
                    //       category: category,
                    //       title: title as String,
                    //       author: author,
                    //     );
                    //     bookWidgets.add(bookWidget);
                    //   }
                    // }
                    // final books = snapshot.data!.docs;
                    // for (var book in books) {
                    //   var title = (book.data() as Map)['title'];
                    //   var author = (book.data() as Map)['author'];
                    //   var owner = (book.data() as Map)['owner'];
                    //   var bookCover = (book.data() as Map)['imageURL'];

                    //   if (owner == loggedInUser.email) {
                    //     Text titleText = Text(title);
                    //     bookTitles.add(titleText);
                    //     Text authorText = Text(author);
                    //     bookAuthors.add(authorText);
                    //     Text coverText = Text(bookCover);
                    //     bookCovers.add(coverText);
                    //   }
                    // }

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                              color: Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                          .toInt())
                                  .withOpacity(1.0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.4),
                                  spreadRadius: 8,
                                  blurRadius: 8,
                                  offset: Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Container(
                                //   margin: EdgeInsets.only(top: 150),
                                //   child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     crossAxisAlignment: CrossAxisAlignment.center,
                                //     children: [
                                //       Stack(
                                //         children: [
                                //           Text(
                                //             "Σαsyβooks ⚡️",
                                //             style: TextStyle(
                                //               fontSize: 30,
                                //               foreground: Paint()
                                //                 ..style = PaintingStyle.stroke
                                //                 ..strokeWidth = 10
                                //                 ..color = Colors.black,
                                //             ),
                                //           ),
                                //           Text(
                                //             "Σαsyβooks",
                                //             style: TextStyle(
                                //               color: Colors.white,
                                //               fontSize: 30,
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          left: 20, top: 100, bottom: 30),
                                      padding: EdgeInsets.only(left: 20),
                                      child: SizedBox(
                                        width: 250.0,
                                        child: DefaultTextStyle(
                                          style: const TextStyle(
                                            fontSize: 30.0,
                                            fontFamily: 'Lato',
                                            fontWeight: FontWeight.bold,
                                          ),
                                          child: AnimatedTextKit(
                                            totalRepeatCount: 5,
                                            animatedTexts: [
                                              TypewriterAnimatedText(
                                                'CATEGORY ⚡️',
                                              ),
                                            ],
                                            onTap: () {
                                              print("Tap Event");
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 70),
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.refresh),
                                        iconSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 200,
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('Fictional');
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      fictionPage()),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/athena_fictional.jpg',
                                              'Fictional'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Non_Fiction_Page()),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/alexander_non_fiction.jpg',
                                              'Non - Fictional'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      HistoricalPage()),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/napoleon_historical.jpg',
                                              'Historical'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhilosophyPage()),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/plato_philosopher.jpg',
                                              'Philosophy'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SciFiPage(),
                                              ),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/sci_fi.jpg',
                                              'Sci - Fi'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ComicPage(),
                                              ),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/comic.jpg',
                                              'Comic'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BiographyPage(),
                                              ),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/biography.jpg',
                                              'Biography'),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DesignPage(),
                                              ),
                                            );
                                          },
                                          child: customSmallContainer(
                                              'assets/images/design.jpg',
                                              'Design'),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          customDivider(),
                          Text(
                            'Your Collection 📚',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length <= 6
                                ? snapshot.data!.docs.length
                                : snapshot.data!.docs.length - 2,
                            itemBuilder: (context, index) {
                              String bookTitle =
                                  snapshot.data!.docs[index]['title'];
                              String bookOwner =
                                  snapshot.data!.docs[index]['owner'];
                              String bookCover =
                                  snapshot.data!.docs[index]['imageURL'];
                              String bookCategory =
                                  snapshot.data!.docs[index]['category'];
                              String bookAuthor =
                                  snapshot.data!.docs[index]['author'];
                              String bookDescription =
                                  snapshot.data!.docs[index]['description'];
                              String bookLanguage =
                                  snapshot.data!.docs[index]['language'];
                              String bookPublished =
                                  snapshot.data!.docs[index]['publishedYear'];
                              String bookPages =
                                  snapshot.data!.docs[index]['numberOfPages'];
                              String bookStartDate =
                                  snapshot.data!.docs[index]['startDate'];
                              String bookEndDate =
                                  snapshot.data!.docs[index]['endDate'];
                              bool bookIsFavourite =
                                  snapshot.data!.docs[index]['isFavourite'];
                              String bookId =
                                  snapshot.data!.docs[index]['bookId'];
                              return (bookOwner == loggedInUser.email)
                                  ? GestureDetector(
                                      key: ValueKey(loggedInUser.email),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          'bookInfo',
                                          arguments: ScreenArguments(
                                            bookTitle,
                                            bookAuthor,
                                            bookCover,
                                            bookCategory,
                                            bookDescription,
                                            bookOwner,
                                            bookLanguage,
                                            bookPublished,
                                            bookPages,
                                            bookStartDate,
                                            bookEndDate,
                                            bookIsFavourite,
                                            bookId,
                                          ),
                                        );
                                      },
                                      child: buildListTile(bookCover,
                                          bookCategory, bookTitle, bookAuthor),
                                    )
                                  : SizedBox(
                                      height: 10,
                                    );
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                      heroTag: 'btnViewAllBooks',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllBooksPage()),
                                        );
                                      },
                                      child: Icon(CupertinoIcons.eye_fill),
                                      backgroundColor: Colors.blue,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    'All your books!',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          customDivider(),
                          Text(
                            'Discover People 😎',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: userSnapshot,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                );
                              }

                              return Container(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius:
                                            3, // how much spread does this shadow goes
                                        blurRadius:
                                            4, // how blurry the shadow is
                                        offset: Offset(
                                            0, 5), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  padding:
                                      EdgeInsets.only(bottom: 20, right: 20),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length <= 4
                                        ? snapshot.data!.docs.length
                                        : snapshot.data!.docs.length - 1,
                                    itemBuilder: (context, index) {
                                      String userUserName = snapshot
                                          .data!.docs[index]['userName'];
                                      String userPfp = snapshot
                                          .data!.docs[index]['profileURL'];
                                      String userEmail =
                                          snapshot.data!.docs[index]['email'];
                                      String userTotalBooks = snapshot
                                          .data!.docs[index]['totalBooks'];
                                      String userTotalFavourites = snapshot
                                          .data!.docs[index]['totalFavourites'];
                                      String userAge =
                                          snapshot.data!.docs[index]['age'];
                                      String userAbout =
                                          snapshot.data!.docs[index]['about'];
                                      String userLocation = snapshot
                                          .data!.docs[index]['location'];
                                      int userCreatedDate = snapshot
                                          .data!.docs[index]['createdDate'];
                                      int userCreatedMonth = snapshot
                                          .data!.docs[index]['createdMonth'];
                                      int userCreatedYear = snapshot
                                          .data!.docs[index]['createdYear'];
                                      bool isShowLocation = snapshot
                                          .data!.docs[index]['showLocation'];
                                      bool isShowAge =
                                          snapshot.data!.docs[index]['showAge'];
                                      bool isShowBook = snapshot
                                          .data!.docs[index]['showBook'];
                                      bool isShowFavourite = snapshot
                                          .data!.docs[index]['showFavourite'];
                                      return Column(
                                        children: [
                                          SizedBox(height: 30),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 20, right: 20),
                                                    child: Text(
                                                      userUserName,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color: Colors.white,
                                                          fontStyle:
                                                              FontStyle.italic),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                      userEmail,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              GestureDetector(
                                                key: ValueKey(
                                                    loggedInUser.email),
                                                onTap: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    'otherUserInfo',
                                                    arguments: UserArguments(
                                                      userAge,
                                                      userEmail,
                                                      userPfp,
                                                      userTotalBooks,
                                                      userUserName,
                                                      userAbout,
                                                      userTotalFavourites,
                                                      userLocation,
                                                      userCreatedDate,
                                                      userCreatedMonth,
                                                      userCreatedYear,
                                                      isShowLocation,
                                                      isShowAge,
                                                      isShowBook,
                                                      isShowFavourite,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 90.0,
                                                  height: 90.0,
                                                  decoration: BoxDecoration(
                                                    color: Colors.deepOrange,
                                                    image: DecorationImage(
                                                      image: userPfp == ''
                                                          ? NetworkImage(
                                                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')
                                                          : NetworkImage(
                                                              '$userPfp'),
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(50.0),
                                                    ),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                          customDivider(),
                          Text(
                            'Analytics 📈',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Container(
                            margin:
                                EdgeInsets.only(top: 20, left: 20, right: 20),
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            height: 300,
                            decoration: BoxDecoration(
                              color: Color(0xFFB03A2E),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius:
                                      3, // how much spread does this shadow goes
                                  blurRadius: 4, // how blurry the shadow is
                                  offset: Offset(
                                      0, 5), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Email : ${loggedInUser.email}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_view_day,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Joined Date : $createdDateDate / $createdDateMonth / $createdDateYear",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.last_page,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Last Signed In : $lastSignInHour H $lastSignInMinute m - $lastSignInDate / $lastSignInMonth / $lastSignInYear",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.explicit,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        child: Text(
                                          "Your profile UID ( Do NOT share! ): ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
                                  child: Text(
                                    "$userUID",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.zero,
                                  margin: EdgeInsets.only(top: 20),
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1DEDE),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MyAccountPage()),
                                      );
                                    },
                                    child: Text(
                                      'See full analytics!',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          customDivider(),
                          Text(
                            'Favourites ❤️',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length <= 6
                                ? snapshot.data!.docs.length
                                : snapshot.data!.docs.length - 3,
                            itemBuilder: (context, index) {
                              String bookTitle =
                                  snapshot.data!.docs[index]['title'];
                              String bookOwner =
                                  snapshot.data!.docs[index]['owner'];
                              String bookCover =
                                  snapshot.data!.docs[index]['imageURL'];
                              String bookCategory =
                                  snapshot.data!.docs[index]['category'];
                              String bookAuthor =
                                  snapshot.data!.docs[index]['author'];
                              String bookDescription =
                                  snapshot.data!.docs[index]['description'];
                              String bookLanguage =
                                  snapshot.data!.docs[index]['language'];
                              String bookPublished =
                                  snapshot.data!.docs[index]['publishedYear'];
                              String bookPages =
                                  snapshot.data!.docs[index]['numberOfPages'];
                              String bookStartDate =
                                  snapshot.data!.docs[index]['startDate'];
                              String bookEndDate =
                                  snapshot.data!.docs[index]['endDate'];
                              bool bookIsFavourite =
                                  snapshot.data!.docs[index]['isFavourite'];
                              String bookId =
                                  snapshot.data!.docs[index]['bookId'];
                              return (bookOwner == loggedInUser.email &&
                                      bookIsFavourite == true)
                                  ? GestureDetector(
                                      key: ValueKey(loggedInUser.email),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          'bookInfo',
                                          arguments: ScreenArguments(
                                            bookTitle,
                                            bookAuthor,
                                            bookCover,
                                            bookCategory,
                                            bookDescription,
                                            bookOwner,
                                            bookLanguage,
                                            bookPublished,
                                            bookPages,
                                            bookStartDate,
                                            bookEndDate,
                                            bookIsFavourite,
                                            bookId,
                                          ),
                                        );
                                      },
                                      child: buildListTile(bookCover,
                                          bookCategory, bookTitle, bookAuthor),
                                    )
                                  : SizedBox(
                                      height: 0,
                                    );
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    'All your Favourites!',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                      heroTag: 'btnFavourite',
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllFavouritesPage()),
                                        );
                                      },
                                      child: Icon(CupertinoIcons.heart_fill),
                                      backgroundColor: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          customDivider(),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScreenArguments {
  late final String bookTitle;
  late final String bookAuthor;
  late final String bookCover;
  late final String bookCategory;
  late final String bookDescription;
  late final String bookOwner;
  late final String bookLanguage;
  late final String bookPublishedYear;
  late final String bookPages;
  late final String bookStartDate;
  late final String bookEndDate;
  late final bool isFavourite;
  late final String bookId;

  ScreenArguments(
    this.bookTitle,
    this.bookAuthor,
    this.bookCover,
    this.bookCategory,
    this.bookDescription,
    this.bookOwner,
    this.bookLanguage,
    this.bookPublishedYear,
    this.bookPages,
    this.bookStartDate,
    this.bookEndDate,
    this.isFavourite,
    this.bookId,
  );
}

class UserArguments {
  late final String age;
  late final String email;
  late final String userPFP;
  late final String totalBooks;
  late final String userUserName;
  late final String userAbout;
  late final String userTotalFavourites;
  late final String userLocation;
  late final int userCreatedDate;
  late final int userCreatedMonth;
  late final int userCreatedYear;
  late final bool isShowLocation;
  late final bool isShowAge;
  late final bool isShowBook;
  late final bool isShowFavourite;

  UserArguments(
    this.age,
    this.email,
    this.userPFP,
    this.totalBooks,
    this.userUserName,
    this.userAbout,
    this.userTotalFavourites,
    this.userLocation,
    this.userCreatedDate,
    this.userCreatedMonth,
    this.userCreatedYear,
    this.isShowLocation,
    this.isShowAge,
    this.isShowBook,
    this.isShowFavourite,
  );
}
