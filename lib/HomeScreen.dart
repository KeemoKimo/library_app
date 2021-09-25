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
  late String? username = '';
  late String? userEmail = loggedInUser.email;
  late String? userUID = loggedInUser.uid;
  late String age = '';
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  File? file;
  late String imageUrl = '';
  late String? owner = '';
  late String? totalBooks = '';
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();

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
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3, // how much spread does this shadow goes
            blurRadius: 0.2, // how blurry the shadow is
            offset: Offset(0, 5), // changes position of shadow
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
                width: 100,
                height: 140,
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
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
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
                  image: AssetImage('assets/images/sask.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
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
                          '$userEmail',
                          style: TextStyle(
                            fontSize: 20,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          '$userEmail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('My Account'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: const Text('All My Books'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AllBooksPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: const Text('Favourites'),
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
              leading: Icon(Icons.help),
              title: const Text('Help'),
              onTap: () async {
                print('Help Pressed');
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text(
                'About Us',
              ),
              onTap: () async {
                print('About Us');
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: const Text(
                'Add Books',
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
              leading: Icon(Icons.logout_outlined),
              title: const Text(
                'Log Out',
              ),
              onTap: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text("LOG OUT"),
                    content: Text(
                        "Are you sure you want to log out of $userEmail ?"),
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
                          Container(
                            child: Text(
                              'Your Collection 📚',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            ),
                          ),
                          // ListView.builder(
                          //   physics: NeverScrollableScrollPhysics(),
                          //   shrinkWrap: true,
                          //   itemCount: bookWidgets.length,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     return bookWidgets;
                          //   },
                          // )
                          ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
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
