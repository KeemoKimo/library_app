import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/BookService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class AllBooksPage extends StatefulWidget {
  final User loggedInUser;
  const AllBooksPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _AllBooksPageState createState() =>
      _AllBooksPageState(loggedInUser: loggedInUser);
}

class _AllBooksPageState extends State<AllBooksPage> {
  late User loggedInUser;
  _AllBooksPageState({required this.loggedInUser});
  late var bookSnapshot = Variables.firestore.collection('books').get();
  TextEditingController _searchController = TextEditingController();
  List allResult = [], searchedResultList = [];
  late Future resultsLoaded;
  var sortByValue = "title";
  var fabIcon = Icons.title;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchchanged);

    build(context);
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
      if (sortByValue == "title") {
        for (var bookSnapshots in allResult) {
          var title =
              UIServices.fromSnapshot(bookSnapshots).title.toLowerCase();
          if (title.contains(_searchController.text.toLowerCase())) {
            showResult.add(bookSnapshots);
          }
        }
      } else if (sortByValue == "bookCategory") {
        for (var bookSnapshots in allResult) {
          var category =
              UIServices.fromSnapshot(bookSnapshots).bookCategory.toLowerCase();
          if (category.contains(_searchController.text.toLowerCase())) {
            showResult.add(bookSnapshots);
          }
        }
      } else if (sortByValue == "bookAuthor") {
        for (var bookSnapshots in allResult) {
          var author =
              UIServices.fromSnapshot(bookSnapshots).bookAuthor.toLowerCase();
          if (author.contains(_searchController.text.toLowerCase())) {
            showResult.add(bookSnapshots);
          }
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ScreenBG/allBooksBackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: UIServices.makeAppBarTextfield(_searchController,
            "Search all your books...", Variables.themePurple),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(20),
              //! CHECK TO SEE IF BOOK MATCHES THE SEARCH
              searchedResultList.length > 0
                  ? ListView.builder(
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
                                      data.bookStartDate.toDate(),
                                      data.bookEndDate.toDate(),
                                      data.bookIsFavourite,
                                      data.bookId,
                                    ),
                                  );
                                },
                                child: UIServices.buildCardTile(
                                    data.bookCover,
                                    data.bookCategory,
                                    data.bookTitle,
                                    data.bookAuthor,
                                    true),
                              )
                            : SizedBox(
                                height: 0,
                              );
                      },
                    )
                  : Center(
                      child: Text(
                        "No books found :(",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Variables.themeHotBookInfo,
          onPressed: () {},
          child: PopupMenuButton(
            color: Variables.themeHotBookInfo,
            icon: Icon(fabIcon),
            elevation: 20,
            enabled: true,
            onSelected: (value) {
              setState(
                () {
                  sortByValue = value.toString();
                  if (value == "title") {
                    fabIcon = Icons.title;
                  } else if (value == "bookCategory") {
                    fabIcon = Icons.category;
                  } else if (value == "bookAuthor") {
                    fabIcon = Icons.person;
                  }
                },
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Container(
                  color: Variables.themeHotBookInfo,
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.title, color: Colors.white),
                      Text("Title", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                value: "title",
              ),
              PopupMenuItem(
                child: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.category, color: Colors.white),
                      Text("Category", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                value: "bookCategory",
              ),
              PopupMenuItem(
                child: Container(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.person, color: Colors.white),
                      Text("Author", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                value: "bookAuthor",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
