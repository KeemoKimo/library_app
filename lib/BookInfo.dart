import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/HomeScreen.dart';

class BookInfo extends StatelessWidget {
  //final String? title;

  const BookInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardId =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('ASFAFA'),
      ),
      body: Container(
        width: 300,
        height: 300,
        color: Colors.red,
        child: Column(
          children: [
            Text(
              cardId.bookTitle,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              cardId.bookAuthor,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              cardId.bookDescription,
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
