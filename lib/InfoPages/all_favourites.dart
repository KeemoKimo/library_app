import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/BookService.dart';
import 'package:library_app/Services/UIServices.dart';

class AllFavouritesPage extends StatefulWidget {
  const AllFavouritesPage({Key? key}) : super(key: key);

  @override
  _AllFavouritesPageState createState() => _AllFavouritesPageState();
}

class _AllFavouritesPageState extends State<AllFavouritesPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String? totalFavourites = '';
  late var bookSnapshot = firestore.collection('books').get();
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

  countFavourites() async {
    QuerySnapshot _myDoc = await firestore
        .collection('books')
        .where('owner', isEqualTo: loggedInUser.email.toString())
        .where(
          'isFavourite',
          isEqualTo: true,
        ) //cannot use ==
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    totalFavourites = _myDocCount.length.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAllBooks();
  }

  _onSearchchanged() {
    searchResultList();
  }

  getAllBooks() async {
    var data = await bookSnapshot;
    setState(() {
      allResult = data.docs;
    });
    searchResultList();
    return "Get all books completed!";
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

  @override
  Widget build(BuildContext context) {
    countFavourites();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Color(0xFF1565C0),
            Color(0xFF642B73),
            Color(0xFFf12711),
            Color(0xFF780206),
            Color(0xFF1D2671),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: UIServices.makeTransparentAppBar(
            _searchController, "Search all your favourites..."),
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
                  return (data.bookIsFavourite == true &&
                          data.bookOwner == loggedInUser.email)
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
            Color(0xFFDF271C),
            Color(0xFFDF271C),
            Colors.white,
            context,
            "You have a total of $totalFavourites favourites !"),
      ),
    );
  }
}
