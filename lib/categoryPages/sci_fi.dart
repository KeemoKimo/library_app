import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class SciFiPage extends StatefulWidget {
  const SciFiPage({Key? key}) : super(key: key);

  @override
  _SciFiPageState createState() => _SciFiPageState();
}

class _SciFiPageState extends State<SciFiPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      firestore.collection('books').snapshots();
  late String? username = '';
  late String? userUID = loggedInUser.uid;
  late String age = '';
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  File? file;
  late String imageUrl = '';
  @override
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(
      () {
        setState(() {
          print(loggedInUser.email);
          build(context);
        });
      },
    );
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF635478),
            Color(0xFF8F7A74),
            Color(0xFF6F5641),
            Color(0xFFD9A497),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('books')
                      .where('owner',
                          isEqualTo: loggedInUser
                              .email) //this only filter the books that have the owner same as the logged in user
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                            color: Colors.red,
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )),
                      );
                    }

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            image: DecorationImage(
                                image: AssetImage('assets/images/sci_fi.jpg'),
                                fit: BoxFit.cover),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Text(
                                  "Sci - Fi",
                                  style: TextStyle(
                                    fontSize: 30,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 10
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  "Sci - Fi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        UIServices.customDivider(Colors.white),
                        Column(
                          children: [
                            ListView.builder(
                              padding: EdgeInsets.zero,
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
                                return (bookOwner == loggedInUser.email &&
                                        bookCategory == 'Sci-Fi')
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
                                            bookCover,
                                            bookCategory,
                                            bookTitle,
                                            bookAuthor),
                                      )
                                    : SizedBox(
                                        height: 0,
                                      );
                              },
                            ),
                          ],
                        ),
                      ],
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
