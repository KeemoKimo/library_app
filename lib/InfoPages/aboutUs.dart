import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
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
import 'package:http/http.dart' as http;

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

var nameController = TextEditingController();
var emailController = TextEditingController();
var subjectController = TextEditingController();
var messageController = TextEditingController();

Future sendEmail({
  required String name,
  required String email,
  required String subject,
  required String message,
}) async {
  final serviceId = 'service_c5gaghb';
  final templateId = 'template_gwixyuv';
  final userId = 'user_K1O3yuCrqJUEDru3j777v';
  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  try {
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode(
        {
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'template_params': {
            'name_sender': name,
            'email_sender': email,
            'user_subject': subject,
            'message': message,
          },
        },
      ),
    );
    print('Email sent');
  } catch (e) {
    print(e);
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

Container rowItem(String imagePath, String firstLineText, String description) {
  return Container(
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
            width: 300,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(10),
            child: Text(
              description,
              style: TextStyle(wordSpacing: 3, fontSize: 15, letterSpacing: 2),
            ),
          ),
        ),
      ],
    ),
  );
}

Container meetTheTeamContainer(String imagePath, String personName,
    String personDescription, double marginValue, String flagPath) {
  return Container(
    margin: EdgeInsets.only(top: 20),
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          width: double.infinity,
          height: 130,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 140,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 3, color: Colors.white),
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(imagePath)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 20),
                width: 190,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Text(
                            personName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: marginValue),
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(flagPath),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                      child: Text(
                        personDescription,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      'Get to know us',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    padding: EdgeInsets.only(left: 20),
                    width: double.infinity,
                    height: 550,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          rowItem('assets/images/dev.png', 'Development',
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: rowItem('assets/images/team.png', 'Our Team',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: rowItem(
                                'assets/images/vision.png',
                                'Our Vision',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 50),
                            child: rowItem(
                                'assets/images/service.png',
                                'Service',
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  customDivider(Colors.white),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      'Meet the team',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        meetTheTeamContainer(
                            'assets/images/CEO.png',
                            'Jürgen Walter',
                            'CEO & Founder',
                            20,
                            'assets/images/germany.png'),
                        meetTheTeamContainer(
                            'assets/images/Co-Founder.png',
                            'Dromos Alexios',
                            'Co-Founder',
                            10,
                            'assets/images/greece.png'),
                        meetTheTeamContainer(
                            'assets/images/manager.png',
                            'Ingrid Anastasia',
                            'Manager',
                            10,
                            'assets/images/norway.png'),
                        meetTheTeamContainer(
                            'assets/images/developer.png',
                            'Bjørn Oddvaren',
                            'Developer',
                            15,
                            'assets/images/denmark.png'),
                        meetTheTeamContainer(
                            'assets/images/developer2.png',
                            'E.Olivia Sinclair',
                            'Developer',
                            20,
                            'assets/images/canada.png'),
                      ],
                    ),
                  ),
                  customDivider(Colors.white),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      "Get in touch!!!",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 630,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            controller: nameController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Enter your name...",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            controller: emailController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Enter your email...",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            controller: subjectController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              labelText: "Enter the subject...",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            maxLength: 1000,
                            controller: messageController,
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              counterStyle: TextStyle(color: Colors.black),
                              labelText: "Write your message...",
                              labelStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.black,
                          ),
                          child: TextButton(
                            onPressed: () {
                              sendEmail(
                                name: nameController.text,
                                email: emailController.text,
                                subject: subjectController.text,
                                message: messageController.text,
                              );
                            },
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 60, right: 10),
                                  child: Text(
                                    "Send!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'assets/images/sending.png'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  customDivider(Colors.white),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    child: Text(
                      "Copyright © - Bunthong / 2021",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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
