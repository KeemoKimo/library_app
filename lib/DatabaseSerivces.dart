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
      String imageURL,
      String language,
      String publishedYear,
      String startDate,
      String endDate,
      bool isFavourite) async {
    return await booksCollection.doc(title + uid).set(
      {
        'category': category,
        'title': title,
        'author': author,
        'numberOfPages': numberOfPages,
        'description': description,
        'owner': owner,
        'imageURL': imageURL,
        'language': language,
        'publishedYear': publishedYear,
        'startDate': startDate,
        'endDate': endDate,
        'isFavourite': isFavourite,
        'bookId': title + uid,
      },
    );
  }

  Future updateUserData(
      String username,
      String age,
      String email,
      String profileURL,
      String totalBooks,
      String location,
      String about,
      String totalFavourites,
      int createdDate,
      int createdMonth,
      int createdYear,
      bool showLocationStatus,
      bool showAgeStatus,
      bool showBookStatus,
      bool showFavouriteStatus) async {
    return await userCollection.doc(uid).set(
      {
        'userName': username,
        'age': age,
        'email': email,
        'profileURL': profileURL,
        'totalBooks': totalBooks,
        'location': location,
        'about': about,
        'totalFavourites': totalFavourites,
        'createdDate': createdDate,
        'createdMonth': createdMonth,
        'createdYear': createdYear,
        'showLocation': showLocationStatus,
        'showAge': showAgeStatus,
        'showBook': showBookStatus,
        'showFavourite': showFavouriteStatus,
      },
    );
  }

  Future updateUserPhoto(String profileURL) async {
    return await userCollection.doc(uid).update(
      {
        'profileURL': profileURL,
      },
    );
  }

  Future updateLocationPrivacyStatus(bool showLocationStatus) async {
    return await userCollection.doc(uid).update(
      {
        'showLocation': showLocationStatus,
      },
    );
  }

  Future updateAgePrivacyStatus(bool showAgeStatus) async {
    return await userCollection.doc(uid).update(
      {
        'showAge': showAgeStatus,
      },
    );
  }

  Future updateBooksPrivacyStatus(bool showBookStatus) async {
    return await userCollection.doc(uid).update(
      {
        'showBook': showBookStatus,
      },
    );
  }

  Future updateFavouritePrivacyStatus(bool showFavouriteStatus) async {
    return await userCollection.doc(uid).update(
      {
        'showFavourite': showFavouriteStatus,
      },
    );
  }

  Future updateFavouriteStatus(
      bool isFavourite, String title, String uid) async {
    return await booksCollection.doc(title + uid).update(
      {
        'isFavourite': isFavourite,
      },
    );
  }

  Future updateTotalBooks(String totalBooks) async {
    return await userCollection.doc(uid).update(
      {
        'totalBooks': totalBooks,
      },
    );
  }

  Future updateTotalFavourites(String totalFavourites) async {
    return await userCollection.doc(uid).update(
      {
        'totalFavourites': totalFavourites,
      },
    );
  }
}
