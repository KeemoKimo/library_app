import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
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
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
  late String? totalFavourites = '';

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
  Widget build(BuildContext context) {
    countFavourites();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'All Favourites',
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('Favourite Info'),
                  content: Text(
                      '${loggedInUser.email} have a total of $totalFavourites favourited books !'),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      child: const Text('Understanable'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: bookSnapshot,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.black,
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
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
                                    child: UIServices.buildCardTile(bookCover,
                                        bookCategory, bookTitle, bookAuthor),
                                  )
                                : SizedBox(
                                    height: 0,
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
    );
  }
}
