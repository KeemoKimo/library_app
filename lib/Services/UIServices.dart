import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/HomeScreen.dart';

class UIServices {
  //!MAKE A DIVIER
  static Container customDivider(Color color) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Divider(
        height: 1,
        thickness: 1,
        color: color,
      ),
    );
  }

  //!MAKE A BOOK CARD
  static Card buildCardTile(
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
                width: 120,
                height: 160,
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
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 15,
      margin: EdgeInsets.all(10),
    );
  }

//!MAKE CUSTOM ERROR POP UP
  static AlertDialog makeDialog(String details, String imagePath) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imagePath),
              ),
            ),
          ),
          Container(
            child: Text(
              "ERROR",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.red,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              details.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Divider(
              height: 1,
              thickness: 1,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }

//!MAKE CUSTOM CARD FOR OTHER USER PAGE
  static Container customCard(
      String displayText,
      IconData firstIcon,
      IconData secondIcon,
      double marginTop,
      Color mainIconColor,
      Color secondIconColor) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: marginTop),
            height: 60,
            child: Card(
              shadowColor: Colors.black,
              elevation: 5,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Icon(
                      firstIcon,
                      color: mainIconColor,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      '$displayText',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 190),
                    child: Icon(
                      secondIcon,
                      size: 15,
                      color: secondIconColor,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//!MAKE CUSTOM BOOK LIST VIEW(CAN SET WETHER TO SHOW FAVOURITES OR NO)
  static ListView bookListViewBuilder(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
      User loggedInUser,
      int maxVisibleLength,
      int minusLength,
      bool isShowFavourite) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      itemCount: snapshot.data!.docs.length <= maxVisibleLength
          ? snapshot.data!.docs.length
          : snapshot.data!.docs.length - minusLength,
      itemBuilder: (context, index) {
        String bookTitle = snapshot.data!.docs[index]['title'];
        String bookOwner = snapshot.data!.docs[index]['owner'];
        String bookCover = snapshot.data!.docs[index]['imageURL'];
        String bookCategory = snapshot.data!.docs[index]['category'];
        String bookAuthor = snapshot.data!.docs[index]['author'];
        String bookDescription = snapshot.data!.docs[index]['description'];
        String bookLanguage = snapshot.data!.docs[index]['language'];
        String bookPublished = snapshot.data!.docs[index]['publishedYear'];
        String bookPages = snapshot.data!.docs[index]['numberOfPages'];
        String bookStartDate = snapshot.data!.docs[index]['startDate'];
        String bookEndDate = snapshot.data!.docs[index]['endDate'];
        bool bookIsFavourite = snapshot.data!.docs[index]['isFavourite'];
        String bookId = snapshot.data!.docs[index]['bookId'];
        return isShowFavourite == false
            ? (bookOwner == loggedInUser.email)
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
                        bookCover, bookCategory, bookTitle, bookAuthor),
                  )
                : SizedBox(
                    height: 10,
                  )
            : (bookOwner == loggedInUser.email && bookIsFavourite == true)
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
                        bookCover, bookCategory, bookTitle, bookAuthor),
                  )
                : SizedBox(
                    height: 10,
                  );
      },
    );
  }
}
