import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';

import '../variables.dart';

class EditProfileService {
  //! PICK COUNTRY CONTAINER
  static makeCountryPicker(String pickedCountry) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Variables.themePurple,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              pickedCountry,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.swap_horizontal_circle_sharp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  //! EDIT PROFILE SCREEN BACKGROUND
  static var editProfileBG = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/ScreenBG/EditProfileBG.png"),
      fit: BoxFit.cover,
    ),
  );

  //! SHOW ERROR POP UP SAVING DATA
  static showErrorPopup(BuildContext context, var e) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup(e.toString(), true);
      },
    );
  }

//! ABOUT ME TEXTBOX (EDIT PROFILE)
  static makeAboutMeTextbox(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Variables.themePurple,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 15,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
          labelText: "About me",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }

//! CUSTOM ALIGN TEXT (EDIT PROFILE)
  static makeCustomAlignedText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Variables.themePurple,
        ),
      ),
    );
  }
}
