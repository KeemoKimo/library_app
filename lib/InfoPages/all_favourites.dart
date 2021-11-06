import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(50),
              Text(
                "All your Favourites",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              UIServices.customDivider(Colors.white),
              UIServices.makeCustomTextField(
                  _searchController, "Search books...", false, 0),
              //! SHOW ALL THE FAVOURITE BOOKS
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
                  return (bookIsFavourite == true &&
                          bookOwner == loggedInUser.email)
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
          backgroundColor: Color(0xFF2E50A5),
          child: Icon(
            Icons.info,
            color: Colors.white,
          ),
          onPressed: () {
            final snackBar = SnackBar(
              duration: Duration(seconds: 2),
              content: Text(
                'You have a total of $totalFavourites favourites!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Color(0xFFDF271C),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          },
        ),
      ),
    );
  }
}
