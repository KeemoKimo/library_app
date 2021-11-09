import 'package:flutter/material.dart';
import 'package:library_app/Services/DecorationService.dart';
import 'package:library_app/Services/UIServices.dart';

class HomeScreenService {
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

//! POPUP BUTTON FOR SIGN OUT
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

//! MAIN SCREEN GRADIENT
  static var bgGradient = BoxDecoration(
    gradient: DecorationService.gradientColor(
      Alignment.bottomLeft,
      Alignment.topRight,
      Color(0xFF1a2a6c),
      Color(0xFF6f0000),
      Color(0xFF512DA8),
      Color(0xFF23074d),
    ),
  );

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

//! MAKE TITE
  static makeTitle(String label) {
    return Text(
      label,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: Colors.white,
      ),
    );
  }
}
