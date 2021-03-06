import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/ScreenService/HomeScreenService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class OtherUserBooks extends StatefulWidget {
  const OtherUserBooks({Key? key}) : super(key: key);

  @override
  _OtherUserBooksState createState() => _OtherUserBooksState();
}

class _OtherUserBooksState extends State<OtherUserBooks> {
  late User loggedInUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      Variables.firestore.collection('books').snapshots();

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments as UserArguments;
    return Container(
      decoration: ResetAndVerifyService.verifyEmailBg,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
          stream: bookSnapshot,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return HomeScreenService.loadingIndicator;
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
                      String bookTitle = snapshot.data!.docs[index]['title'];
                      String bookOwner = snapshot.data!.docs[index]['owner'];
                      String bookCover = snapshot.data!.docs[index]['imageURL'];
                      String bookCategory =
                          snapshot.data!.docs[index]['category'];
                      String bookAuthor = snapshot.data!.docs[index]['author'];

                      return (bookOwner == userID.email)
                          ? UIServices.buildCardTile(bookCover, bookCategory,
                              bookTitle, bookAuthor, false)
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
      ),
    );
  }
}
