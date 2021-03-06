import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:lottie/lottie.dart';

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
    final bool isVisible,
  ) {
    return Card(
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Stack(
        children: [
          Container(
            color: Colors.grey[200],
            child: Row(
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
                  padding: EdgeInsets.all(20),
                  width: isVisible == true ? 230 : 250,
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
                Visibility(
                  visible: isVisible,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 15,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 12,
      shadowColor: Colors.black,
      margin: EdgeInsets.all(10),
    );
  }

//!MAKE CUSTOM ERROR POP UP
  static AlertDialog showPopup(String details, bool isError) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (isError == true)
              ? Container(
                  width: 150,
                  height: 150,
                  child: Lottie.asset('assets/Animations/error.json'),
                )
              : Container(
                  width: 150,
                  height: 150,
                  child: Lottie.asset('assets/Animations/check.json'),
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
                        bookCover, bookCategory, bookTitle, bookAuthor, true),
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
                        bookCover, bookCategory, bookTitle, bookAuthor, true),
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
    bookIsFavourite = snapshot['isFavourite'];
    bookId = snapshot['bookId'];
  }

//! MAKE A CUSTOM TEXTFIELD INPUT
  static Container makeCustomTextField(TextEditingController controllerName,
      String labelText, BuildContext context, bool isMaxLength, int maxAmount) {
    return isMaxLength == true
        ? Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF4D028A),
            ),
            child: TextFormField(
              controller: controllerName,
              textAlign: TextAlign.center,
              maxLength: maxAmount,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                counterStyle: TextStyle(color: Colors.white),
                isDense: false,
                contentPadding:
                    EdgeInsets.only(left: 11, right: 3, top: 5, bottom: 14),
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 0.1,
                ),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter in the field!!";
                }
                return null;
              },
            ),
          )
        : Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xFF4D028A),
            ),
            child: TextFormField(
              controller: controllerName,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                isDense: false,
                contentPadding:
                    EdgeInsets.only(left: 11, right: 3, top: 5, bottom: 14),
                labelText: labelText,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none),
                errorStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 0.1,
                ),
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Enter in the field!!";
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
        heroTag: null,
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

//!  APP BAR TEXTFIELD
  static AppBar makeAppBarTextfield(
      TextEditingController controller, String hintText, Color color) {
    return AppBar(
      elevation: 0,
      backgroundColor: color,
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

  //!FUNCTION TO MAKE THE ROW WIDGET WITH ICON AND TEXT
  static Row makeRowItem(
      IconData icon, String leadingText, String trailingText, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 10),
          child: Text(
            '$leadingText : $trailingText',
            style: TextStyle(
              fontSize: 16,
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

  //! MAIN BOX SHADOW THEME
  static var mainBoxShadow = BoxShadow(
    color: Colors.black.withOpacity(0.7),
    spreadRadius: 2, // how much spread does this shadow goes
    blurRadius: 3, // how blurry the shadow is
    offset: Offset(0, 5), // changes position of shadow
  );
}
