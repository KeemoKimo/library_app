import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/HomeScreen.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({Key? key}) : super(key: key);

  @override
  _AllBooksPageState createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
  late String? totalBooks = '';

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
  Widget build(BuildContext context) {
    countBooks();
    return Scaffold(
      backgroundColor: Color(0xFFB03A2E),
      appBar: AppBar(
        backgroundColor: Color(0xFFB03A2E),
        title: Text(
          'All Your Books',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.info,
              color: Colors.white,
            ),
            onPressed: () {
              showCupertinoDialog<void>(
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text('All Books'),
                  content: Text(
                      '${loggedInUser.email} have a total of $totalBooks books!'),
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
        color: Color(0xFFB03A2E),
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
                                    child: HomeScreen.buildListTile(bookCover,
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
