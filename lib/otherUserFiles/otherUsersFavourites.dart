import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class OtherUsersFavourites extends StatefulWidget {
  const OtherUsersFavourites({Key? key}) : super(key: key);

  @override
  _OtherUsersFavouritesState createState() => _OtherUsersFavouritesState();
}

class _OtherUsersFavouritesState extends State<OtherUsersFavourites> {
  late User loggedInUser;
  late Stream<QuerySnapshot<Map<String, dynamic>>> bookSnapshot =
      Variables.firestore.collection('books').snapshots();

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments as UserArguments;
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: StreamBuilder<QuerySnapshot>(
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
                      String bookTitle = snapshot.data!.docs[index]['title'];
                      String bookOwner = snapshot.data!.docs[index]['owner'];
                      String bookCover = snapshot.data!.docs[index]['imageURL'];
                      String bookCategory =
                          snapshot.data!.docs[index]['category'];
                      String bookAuthor = snapshot.data!.docs[index]['author'];
                      bool bookIsFavourite =
                          snapshot.data!.docs[index]['isFavourite'];

                      return (bookOwner == userID.email &&
                              bookIsFavourite == true)
                          ? UIServices.buildCardTile(
                              bookCover, bookCategory, bookTitle, bookAuthor)
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
