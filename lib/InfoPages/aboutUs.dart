import 'dart:async';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/categoryPages/biography.dart';
import 'package:library_app/categoryPages/comic.dart';
import 'package:library_app/categoryPages/design.dart';
import 'package:library_app/categoryPages/fiction.dart';
import 'package:library_app/categoryPages/historical.dart';
import 'package:library_app/categoryPages/non_fiction.dart';
import 'package:library_app/categoryPages/philosophy.dart';
import 'package:library_app/categoryPages/sci_fi.dart';
import 'package:library_app/main.dart';
import 'dart:math' as math;

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
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

Container rowItem(String imagePath, String firstLineText, String description) {
  return Container(
    color: Colors.green,
    child: Column(
      children: [
        Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('$imagePath'), fit: BoxFit.cover),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: Text(
            '$firstLineText',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        Center(
          child: Container(
            color: Colors.blue,
            width: 300,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: Text(
              description,
              style: TextStyle(wordSpacing: 2, fontSize: 15),
            ),
          ),
        ),
      ],
    ),
  );
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.white,
        fontFamily: 'Lato',
      ),
      home: Scaffold(
        body: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        'About Us !',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  customDivider(Colors.white),
                  Text(
                    'Get to know us',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20),
                    width: double.infinity,
                    height: 550,
                    color: Colors.red,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          rowItem('assets/images/dev.png', 'Development',
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam')
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
