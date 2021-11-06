import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/BookService.dart';
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
            Color(0xFF1565C0),
            Color(0xFF642B73),
            Color(0xFFf12711),
            Color(0xFFf5af19),
            Color(0xFF1D2671),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: UIServices.makeTransparentAppBar(
            _searchController, "Search all your books..."),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(20),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: searchedResultList.length,
                itemBuilder: (context, index) {
                  var data =
                      BookService.fromSnapshot(searchedResultList, index);
                  return (data.bookOwner == loggedInUser.email)
                      ? GestureDetector(
                          key: ValueKey(loggedInUser.email),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'bookInfo',
                              arguments: ScreenArguments(
                                data.bookTitle,
                                data.bookAuthor,
                                data.bookCover,
                                data.bookCategory,
                                data.bookDescription,
                                data.bookOwner,
                                data.bookLanguage,
                                data.bookPublished,
                                data.bookPages,
                                data.bookStartDate,
                                data.bookEndDate,
                                data.bookIsFavourite,
                                data.bookId,
                              ),
                            );
                          },
                          child: UIServices.buildCardTile(
                              data.bookCover,
                              data.bookCategory,
                              data.bookTitle,
                              data.bookAuthor),
                        )
                      : SizedBox(
                          height: 0,
                        );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: UIServices.makeFABInfoBooks(
            Color(0xFF464290),
            Color(0xFF464290),
            Colors.white,
            context,
            "You have a total of $totalBooks books!"),
      ),
    );
  }
}
