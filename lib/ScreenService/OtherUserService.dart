import 'package:flutter/material.dart';
import 'package:library_app/variables.dart';

class OtherUserService {
  //! MAIN CONTAINER DECORATION
  static var containerDecor = BoxDecoration(
    color: Variables.themePurple,
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
  );

  //! TEXT FOR USERNAME
  static showUsernameText(var userID) {
    return Text(
      userID.userUserName,
      style: TextStyle(
        fontSize: 20,
        color: Variables.themePurple,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //! TEXT FOR EMAIL
  static showUserEmail(var userID) {
    return Text(
      userID.email,
      style: TextStyle(
          fontSize: 15,
          color: Variables.themePurple,
          fontStyle: FontStyle.italic),
    );
  }

  //! MAKE CARD FOR ALL BOOKS & FAVOURITES
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
}
