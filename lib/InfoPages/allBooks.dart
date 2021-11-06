import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({Key? key}) : super(key: key);

  @override
  _AllBooksPageState createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late var bookSnapshot = firestore.collection('books').get();
  late String? totalBooks = '';
  TextEditingController _searchController = TextEditingController();
  List allResult = [], searchedResultList = [];
  late Future resultsLoaded;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchchanged);
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

//! COUNT ALL USER BOOKS WHEN PAGE IS LOADED
  countBooks() async {
    QuerySnapshot _myDoc = await firestore
        .collection('books')
        .where('owner',
            isEqualTo: loggedInUser.email.toString()) //cannot use ==
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    totalBooks = _myDocCount.length.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAllBooks();
  }

  _onSearchchanged() {
    searchResultList();
  }

//! SHOW ALL THE LIST OF BOOKS WHEN THE VALUE IS CHANGED IN TEXTFIELD
  searchResultList() {
    var showResult = [];
    if (_searchController.text != "") {
      //have search parameter
      for (var bookSnapshots in allResult) {
        var title = UIServices.fromSnapshot(bookSnapshots).title.toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResult.add(bookSnapshots);
        }
      }
    } else {
      showResult = List.from(allResult);
    }
    setState(() {
      searchedResultList = showResult;
    });
  }

//! GET ALL THE BOOKS FROM FIREBASE AND STORE IT IN A LIST
  getAllBooks() async {
    var data = await bookSnapshot;
    setState(() {
      allResult = data.docs;
    });
    searchResultList();
    return "Get all books completed!";
  }

  @override
  Widget build(BuildContext context) {
    countBooks();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF333399),
            Color(0xFFb92b27),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(50),
              Text(
                "All your books",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              UIServices.customDivider(Colors.white),
              UIServices.makeCustomTextField(
                  _searchController, "Search books...", false, 0),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchedResultList.length,
                itemBuilder: (context, index) {
                  String bookTitle = searchedResultList[index]['title'];
                  String bookOwner = searchedResultList[index]['owner'];
                  String bookCover = searchedResultList[index]['imageURL'];
                  String bookCategory = searchedResultList[index]['category'];
                  String bookAuthor = searchedResultList[index]['author'];
                  String bookDescription =
                      searchedResultList[index]['description'];
                  String bookLanguage = searchedResultList[index]['language'];
                  String bookPublished =
                      searchedResultList[index]['publishedYear'];
                  String bookPages = searchedResultList[index]['numberOfPages'];
                  String bookStartDate = searchedResultList[index]['startDate'];
                  String bookEndDate = searchedResultList[index]['endDate'];
                  bool bookIsFavourite =
                      searchedResultList[index]['isFavourite'];
                  String bookId = searchedResultList[index]['bookId'];
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
                          child: UIServices.buildCardTile(
                              bookCover, bookCategory, bookTitle, bookAuthor),
                        )
                      : SizedBox(
                          height: 0,
                        );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                'You have a total of $totalBooks books!',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.green,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
