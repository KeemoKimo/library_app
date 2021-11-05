import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/Services/UIServices.dart';

class BookInfo extends StatefulWidget {
  const BookInfo({Key? key}) : super(key: key);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  late User loggedInUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
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
    late Widget cancelBtn = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
    late Widget deleteBtn = TextButton(
      onPressed: () async {
        await bookCollection.doc(bookID.bookTitle + loggedInUser.uid).delete();
        Navigator.pop(context);
        Navigator.pop(context);
        final snackBar = SnackBar(
          content: Text(
            'Your book has been deleted successfully!',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      child: Text(
        "Delete",
        style: TextStyle(
          color: Colors.red,
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BOOK DETAILS',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFFB03A2E),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFB03A2E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 20),
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
                  width: 300,
                  height: 450,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: Image.network(
                      bookID.bookCover,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                                          .updateFavouriteStatus(
                                              isFavouriteState,
                                              bookID.bookTitle,
                                              loggedInUser.uid);
                                      var snackBar = SnackBar(
                                        content: Text('Added to favourites'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.pop(context);
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
                                          .updateFavouriteStatus(
                                              isFavouriteState,
                                              bookID.bookTitle,
                                              loggedInUser.uid);
                                      var snackBar = SnackBar(
                                        content:
                                            Text('Removed from favourites'),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      Navigator.pop(context);
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
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    bookID.bookCategory,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFFB03A2E),
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  bookID.bookAuthor,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            bookID.bookPages,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'pages',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2,
                        color: Color(0xFFB03A2E),
                        height: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            bookID.bookLanguage,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'language',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 2,
                        color: Color(0xFFB03A2E),
                        height: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            bookID.bookPublishedYear,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Text(
                              'published',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                UIServices.customDivider(Colors.black),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFB03A2E),
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
                UIServices.customDivider(Colors.black),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: bookID.bookTitle,
        onPressed: () {
          Navigator.pushNamed(
            context,
            'editBook',
            arguments: ScreenArguments(
              bookID.bookTitle,
              bookID.bookAuthor,
              bookID.bookCover,
              bookID.bookCategory,
              bookID.bookDescription,
              bookID.bookOwner,
              bookID.bookLanguage,
              bookID.bookPublishedYear,
              bookID.bookPages,
              bookID.bookStartDate,
              bookID.bookEndDate,
              bookID.isFavourite,
              bookID.bookId,
            ),
          );
        },
        child: Align(
          alignment: Alignment.bottomRight,
          child: SpeedDial(
            animatedIcon: AnimatedIcons.menu_arrow,
            spaceBetweenChildren: 10,
            overlayColor: Colors.black,
            overlayOpacity: 0.7,
            backgroundColor: Colors.green,
            children: [
              SpeedDialChild(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Icon(Icons.photo),
                label: "Edit Cover",
                onTap: () {
                  print("fasf");
                },
              ),
              SpeedDialChild(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                child: Icon(Icons.settings),
                label: "Edit Information",
                onTap: () {
                  print("Edit Info");
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
                          cancelBtn,
                          deleteBtn,
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
