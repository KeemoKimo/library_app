import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/categoryPages/SelectCategoryPage.dart';
import 'package:library_app/myAccount.dart';
import 'package:page_transition/page_transition.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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

//! GIVING ANIMATION (SLIDING)
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true).timeout(Duration(seconds: 2 * 10), onTimeout: () {
      _controller.forward(from: 0);
      _controller.stop(canceled: true);
    });
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));

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
                Icons.info,
                color: Color(0xFFA50104),
              ),
              title: const Text(
                'About Us',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                Navigator.pushNamed(
                  context,
                  'aboutUs',
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
              leading: Icon(Icons.login_outlined, color: Colors.white),
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

    //! MAIN SCREEN
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
                            margin: EdgeInsets.only(top: 500),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.blue,
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
                          //! CONTAINER FOR CATEGORIES
                          Container(
                            width: double.infinity,
                            height: 400,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft,
                                colors: [
                                  Color(0xFF614385),
                                  Color(0xFF516395),
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
                                  offset: Offset(
                                      0, 7), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SlideTransition(
                                  position: _offsetAnimation,
                                  child: Text(
                                    "WELCOME !!",
                                    style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                UIServices.customDivider(Colors.black),
                                Text(
                                  "We're glad to see you!",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        child: SelectCategoryPage(),
                                        type: PageTransitionType.fade,
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 50),
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: 80,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFFFE347),
                                          Color(0xFF6457A6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        width: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              alignment:
                                                  FractionalOffset.topCenter,
                                              image: AssetImage(
                                                  "assets/images/categories.png"),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 240,
                                          child: Center(
                                            child: Text(
                                              "BROWSE CATEGORIES",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 51,
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                            ),
                                          ),
                                        ),
                                      ],
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
                          UIServices.bookListViewBuilder(
                              snapshot, loggedInUser, 5, 2, false),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AllBooksPage()),
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
                                      image: AssetImage(
                                          'assets/images/allBooks.png'),
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
                          //! LIST FOR ALL USERS (SOME)
                          UIServices.customDivider(Colors.black),
                          Text(
                            'Discover People 😎',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Color(0xFF331832),
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: userSnapshot,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                  ),
                                );
                              }

                              return Container(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF331832),
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
                          UIServices.bookListViewBuilder(
                              snapshot, loggedInUser, 6, 3, true),
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
                                    margin:
                                        EdgeInsets.only(left: 20, right: 20),
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

//TODO THE CLASS TO PASS ALL OF THE BOOKS (CLICKED) INFO TO ANOTHER SCREEN
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

//TODO THE CLASS TO PASS ALL OF THE  LOGGED IN USER (CLICKED) INFO TO ANOTHER SCREEN
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
