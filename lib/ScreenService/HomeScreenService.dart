import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DecorationService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/main.dart';
import 'package:library_app/variables.dart';

class HomeScreenService {
//! MAIN PICTURE FOR HOMESCREEN
  static var mainPicture = Container(
    width: double.infinity,
    height: 400,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/books.jpg'),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.grey, BlendMode.darken),
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 8,
          blurRadius: 8,
          offset: Offset(0, 7), // changes position of shadow
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Choose what",
              style: TextStyle(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "to do today?",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );

//! CIRCLE LOADING INDICATOR
  static var loadingIndicator = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          backgroundColor: Colors.white,
        ),
        UIServices.makeSpace(50),
        Text(
          "Loading data...",
          style: TextStyle(color: Colors.blue),
        ),
      ],
    ),
  );

//! BUILD EACH TILE FOR THE APP DRAWER
  static buildListTile(IconData icon, Color? iconColor, String titleText,
      var goToPage, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        titleText,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => goToPage,
          ),
        );
      },
    );
  }

//! POPUP BUTTON FOR SIGN OUT / CANCEL
  static makeCancelButton(BuildContext context) {
    return UIServices.makePopUpButton(() {
      Navigator.pop(context);
    }, "Cancel", Colors.blue);
  }

  static makeSignOutButton(BuildContext context, var auth, destinationPage) {
    return UIServices.makePopUpButton(() async {
      await auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => destinationPage,
        ),
      );
    }, "Sign Out", Colors.red);
  }

//! MAKE CUSTOM TITLE
  static customTitle(
    String firstText,
    secondText,
    var alignment,
    boldLeft,
    boldRight,
    setColor,
    double marginAmount,
    bool isLeft,
    isRight,
  ) {
    return Container(
      margin: EdgeInsets.only(
          left: (isLeft == true) ? 20 : 0, right: (isRight == true) ? 30 : 0),
      alignment: alignment,
      child: Text.rich(
        TextSpan(
          style: TextStyle(fontSize: 30),
          children: [
            TextSpan(
              text: firstText,
              style: TextStyle(
                fontWeight:
                    (boldLeft == true) ? FontWeight.bold : FontWeight.normal,
                color: (boldLeft == true) ? Color(setColor) : Colors.black,
              ),
            ),
            TextSpan(
              text: secondText,
              style: TextStyle(
                fontWeight:
                    (boldRight == true) ? FontWeight.bold : FontWeight.normal,
                color: (boldRight == true) ? Color(setColor) : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

//! MAKE HOT BOOKS SECTION
  static verticalBookList(
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 6,
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
          Timestamp bookStartDate = snapshot.data!.docs[index]['startDate'];
          DateTime startDate = bookStartDate.toDate();
          Timestamp bookEndDate = snapshot.data!.docs[index]['endDate'];
          DateTime endDate = bookEndDate.toDate();
          bool bookIsFavourite = snapshot.data!.docs[index]['isFavourite'];
          String bookId = snapshot.data!.docs[index]['bookId'];
          return Container(
            padding: EdgeInsets.all(20),
            width: 300,
            height: 300,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  'HotBookInfo',
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
                    startDate,
                    endDate,
                    bookIsFavourite,
                    bookId,
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    width: 230,
                    height: 310,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(bookCover),
                        ),
                        boxShadow: [UIServices.mainBoxShadow]),
                  ),
                  UIServices.makeSpace(20),
                  Text(
                    bookTitle,
                    style: TextStyle(
                        color: Variables.themeHotBookInfo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

//! MAKE DRAWER HEADER
  static makeDrawerHeader(var loggedInUser) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage('assets/images/booksDrawerCover.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3, // how much spread does this shadow goes
            blurRadius: 3, // how blurry the shadow is
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  Text(
                    '${loggedInUser.email}',
                    style: TextStyle(
                      fontSize: 23,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6
                        ..color = Colors.black,
                    ),
                  ),
                  Text(
                    '${loggedInUser.email}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//! MAKE LOGOUT FUNCTION FOR LISTILE
  static logOut(BuildContext context, var auth) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Do you want to sign out?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Text("You are about to sign out of this account."),
          actions: [
            HomeScreenService.makeCancelButton(context),
            HomeScreenService.makeSignOutButton(
              context,
              auth,
              LoginPage(),
            ),
          ],
        );
      },
    );
  }

//! MAKE DRAWER DIVIDER
  static var makeDivider = Divider(
    height: 1,
    thickness: 1,
    color: Colors.black,
  );

//! MAKE LOG OUT LISTILE
  static makeLogOutListTile(BuildContext context, var auth) {
    return ListTile(
      tileColor: Colors.red,
      leading: Icon(Icons.login_outlined, color: Colors.white),
      title: const Text(
        'Log Out',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      onTap: () async {
        HomeScreenService.logOut(context, auth);
      },
    );
  }
}
