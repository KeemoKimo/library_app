import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseServices {
  late String uid;
  DatabaseServices({required this.uid});
  //reference to the firestore collection
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference booksCollection =
      FirebaseFirestore.instance.collection('books');

  Future updateBooksData(
      String category,
      String title,
      String author,
      String numberOfPages,
      String description,
      String owner,
      String imageURL) async {
    return await booksCollection.doc(title + ' from ' + owner).set(
      {
        'category': category,
        'title': title,
        'author': author,
        'numberOfPages': numberOfPages,
        'description': description,
        'owner': owner,
        'imageURL': imageURL,
      },
    );
  }

  Future updateUserData(String username, String age, String email) async {
    return await userCollection.doc(uid).set(
      {
        'userName': username,
        'age': age,
        'email': email,
      },
    );
  }

  Future getUserData() async {
    return userCollection
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        //print out a specific field of data
        print('Document data: ${(documentSnapshot.data() as Map)['userName']}');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  //update whenever something change
  userDataStream() async {
    await for (var snapshot in userCollection.snapshots()) {
      for (var datas in snapshot.docs) {
        print(datas.data());
      }
    }
  }
}
