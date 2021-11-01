import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../HomeScreen.dart';

class PhilosophyPage extends StatefulWidget {
  const PhilosophyPage({Key? key}) : super(key: key);

  @override
  _PhilosophyPageState createState() => _PhilosophyPageState();
}

class _PhilosophyPageState extends State<PhilosophyPage> {
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

  Container customDivider(Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }

  Card buildListTile(
    final String bookCoverURL,
    final String category,
    final String title,
    final String author,
  ) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(bookCoverURL)),
                ),
              ),
              Container(
                width: 230,
                //color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      category.toString(),
                      style: TextStyle(
                        color: Color(0xFFB03A2E),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        title.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Text(
                        (author),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 15,
              )
            ],
          ),
        ],
      ),
      //color: Colors.yellowAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 10,
      margin: EdgeInsets.all(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFFD2BFA9),
            Color(0xFFEADDCA),
            Color(0xFFA5BBD1),
            Color(0xFF83735D),
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
                                image: AssetImage(
                                    'assets/images/plato_philosopher.jpg'),
                                fit: BoxFit.cover),
                          ),
                          child: Center(
                            child: Stack(
                              children: [
                                Text(
                                  "Philosophy",
                                  style: TextStyle(
                                    fontSize: 30,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 10
                                      ..color = Colors.black,
                                  ),
                                ),
                                Text(
                                  "Philosophy",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        customDivider(Colors.black),
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
                                        bookCategory == 'Philosophy')
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
                                        child: buildListTile(
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
