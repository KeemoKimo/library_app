import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/ScreenService/AllBooksService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/BookService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class AllFavouritesPage extends StatefulWidget {
  final User loggedInUser;
  const AllFavouritesPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _AllFavouritesPageState createState() =>
      _AllFavouritesPageState(loggedInUser: loggedInUser);
}

class _AllFavouritesPageState extends State<AllFavouritesPage> {
  late User loggedInUser;
  _AllFavouritesPageState({required this.loggedInUser});
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
    setState(() {
      build(context);
    });
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
      AllBookService.checkSearchResult(
          sortByValue, allResult, _searchController, showResult);
    } else {
      showResult = List.from(allResult);
    }
    setState(() {
      searchedResultList = showResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/ScreenBG/favBooksBackground.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: UIServices.makeAppBarTextfield(
            _searchController, "Search all your favourites...", Colors.red),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(20),
              //! CHECK IF BOOK MATCHES THE RESULT
              searchedResultList.length > 0
                  ? ListView.builder(
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
                  : Column(
                      children: [
                        UIServices.makeSpace(50),
                        Center(
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
                  AllBookService.changeFABFilter(value, context);
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
                child: AllBookService.makeFilterItemContainer(
                    Icons.title, "Title"),
                value: "title",
              ),
              PopupMenuItem(
                child: AllBookService.makeFilterItemContainer(
                    Icons.category, "Category"),
                value: "bookCategory",
              ),
              PopupMenuItem(
                child: AllBookService.makeFilterItemContainer(
                    Icons.person, "Author"),
                value: "bookAuthor",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
