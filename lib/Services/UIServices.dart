import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:library_app/Services/Arguments.dart';
import 'BookService.dart';

class UIServices {
  //!VARIABLES FOR GETTING BOOK INFORMATION
  late String title;
  late String owner;
  late String bookCover;
  late String bookCategory;
  late String bookAuthor;
  late String bookDescription;
  late String bookLanguage;
  late String bookPublished;
  late String bookPages;
  late String bookStartDate;
  late String bookEndDate;
  late bool bookIsFavourite;
  late String bookId;

  //!MAKE A DIVIDER
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
  static AlertDialog showPopup(String details, String imagePath, bool isError) {
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
          (isError == true)
              ? Container(
                  child: Text(
                    "ERROR",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              : Container(
                  child: Text(
                    "SUCCESS",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
          (isError == true)
              ? Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.red,
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.green,
                  ),
                ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: Text(
              details.toString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          (isError == true)
              ? Container(
                  margin: EdgeInsets.all(20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.red,
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.green,
                  ),
                ),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Icon(
                    secondIcon,
                    size: 15,
                    color: secondIconColor,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//!GENERATE CUSTOM BOOK LIST VIEW(CAN SET WETHER TO SHOW FAVOURITES OR NO)
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
        Timestamp bookStartDate = snapshot.data!.docs[index]['startDate'];
        DateTime startDate = bookStartDate.toDate();
        Timestamp bookEndDate = snapshot.data!.docs[index]['endDate'];
        DateTime endDate = bookEndDate.toDate();
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
                          startDate,
                          endDate,
                          bookIsFavourite,
                          bookId,
                        ),
                      );
                    },
                    child: UIServices.buildCardTile(
                        bookCover, bookCategory, bookTitle, bookAuthor),
                  )
                : SizedBox(
                    height: 0,
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
                          startDate,
                          endDate,
                          bookIsFavourite,
                          bookId,
                        ),
                      );
                    },
                    child: UIServices.buildCardTile(
                        bookCover, bookCategory, bookTitle, bookAuthor),
                  )
                : SizedBox(
                    height: 0,
                  );
      },
    );
  }

//! GET SNAPSHOTS (BOOKS)
  UIServices.fromSnapshot(DocumentSnapshot snapshot) {
    title = snapshot['title'];
    owner = snapshot['owner'];
    bookCover = snapshot['imageURL'];
    bookCategory = snapshot['category'];
    bookAuthor = snapshot['author'];
    bookDescription = snapshot['description'];
    bookLanguage = snapshot['language'];
    bookPublished = snapshot['publishedYear'];
    bookPages = snapshot['numberOfPages'];
    bookStartDate = snapshot['startDate'];
    bookEndDate = snapshot['endDate'];
    bookIsFavourite = snapshot['isFavourite'];
    bookId = snapshot['bookId'];
  }

//! MAKE A CUSTOM TEXTFIELD INPUT
  static Container makeCustomTextField(TextEditingController controllerName,
      String labelText, bool isEnforceMaxLength, int txtMaxLength) {
    return isEnforceMaxLength == false
        ? Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              controller: controllerName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: TextFormField(
              maxLength: txtMaxLength,
              controller: controllerName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                counterStyle: TextStyle(color: Colors.white),
                labelText: labelText,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          );
  }

//! MAKE A CUSTOM SPACE BETWEEN WIDGETS
  static SizedBox makeSpace(double value) {
    return SizedBox(
      height: value,
    );
  }

//! CUSTOM TEXT WITH ALIGNMENT
  static Align customAlignedText(
      Alignment alignment, String text, Color color) {
    return Align(
      alignment: alignment,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Text(
          text,
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: color),
        ),
      ),
    );
  }

//! SCROLL TO ITEM
  static Future scrollToItem(GlobalKey keyName) async {
    final context = keyName.currentContext!;
    await Scrollable.ensureVisible(context, duration: Duration(seconds: 1));
  }

//! MAKE SPEEDIAL
  static Align makeSpeedDial(
    Color mainColor,
    IconData firstIcons,
    Color firstBackColor,
    Color firstForeColor,
    String firstLabel,
    Function()? firstFunction,
    IconData secondIcons,
    Color secondBackColor,
    Color secondForeColor,
    String secondLabel,
    Function()? secondFunction,
  ) {
    return Align(
      alignment: Alignment.bottomRight,
      child: SpeedDial(
        icon: Icons.settings,
        animatedIcon: AnimatedIcons.menu_close,
        spaceBetweenChildren: 10,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        backgroundColor: mainColor,
        children: [
          SpeedDialChild(
            backgroundColor: firstBackColor,
            foregroundColor: firstForeColor,
            child: Icon(firstIcons),
            label: firstLabel,
            onTap: firstFunction,
          ),
          SpeedDialChild(
            backgroundColor: secondBackColor,
            foregroundColor: secondForeColor,
            child: Icon(secondIcons),
            label: secondLabel,
            onTap: secondFunction,
          ),
        ],
      ),
    );
  }

//! TRANSPARENT APP BAR TEXTFIELD
  static AppBar makeTransparentAppBar(
      TextEditingController controller, String hintText) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: Container(
        height: 50,
        child: TextField(
          style: TextStyle(color: Colors.white),
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            fillColor: Colors.transparent,
            filled: true,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(
              fontSize: 15,
              color: Colors.white,
            ),
            hintText: hintText,
          ),
        ),
      ),
    );
  }

//! FAB INFO BOOKS
  static FloatingActionButton makeFABInfoBooks(Color fabBgColor,
      snackBarBgColor, snackBarFgColor, BuildContext context, String content) {
    return FloatingActionButton(
      backgroundColor: fabBgColor,
      child: Icon(
        Icons.info,
        color: Colors.white,
      ),
      onPressed: () {
        final snackBar = SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            content,
            style: TextStyle(
              color: snackBarFgColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: snackBarBgColor,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }

//! CATEGORY PAGE SERVICE
  static Column makeCategoryPage(
      String categoryName, imagePath, var allResult, loggedInUser) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: Stack(
              children: [
                Text(
                  categoryName,
                  style: TextStyle(
                    fontSize: 30,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 10
                      ..color = Colors.black,
                  ),
                ),
                Text(
                  categoryName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
        UIServices.customDivider(Colors.black),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allResult.length,
          itemBuilder: (context, index) {
            var data = BookService.fromSnapshot(allResult, index);
            return (data.bookOwner == loggedInUser.email &&
                    data.bookCategory == categoryName)
                ? GestureDetector(
                    key: ValueKey(loggedInUser.email),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'bookInfo',
                        arguments: ScreenArguments(
                          data.bookTitle,
                          data.bookAuthor,
                          data.bookCover,
                          data.bookCategory,
                          data.bookDescription,
                          data.bookOwner,
                          data.bookLanguage,
                          data.bookPublished,
                          data.bookPages,
                          data.bookStartDate,
                          data.bookEndDate,
                          data.bookIsFavourite,
                          data.bookId,
                        ),
                      );
                    },
                    child: UIServices.buildCardTile(data.bookCover,
                        data.bookCategory, data.bookTitle, data.bookAuthor),
                  )
                : SizedBox(
                    height: 0,
                  );
          },
        ),
      ],
    );
  }

  //!FUNCTION TO MAKE THE ROW WIDGET WITH ICON AND TEXT
  static Row makeRowItem(
      IconData icon, String leadingText, String trailingText, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 25,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '$leadingText : $trailingText',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

//! CREATE POP UP TEXT BUTTON
  static TextButton makePopUpButton(
      Function()? func, String labelText, Color textColor) {
    return TextButton(
      onPressed: func,
      child: Text(
        labelText,
        style: TextStyle(
          color: textColor,
        ),
      ),
    );
  }
}
