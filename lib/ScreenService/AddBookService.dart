import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class AddBookService {
  //! (SCREEN 1) - IMAGE CONTAINER
  static makeImageContainer(var _image) {
    return Container(
      width: double.infinity,
      height: 600,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [UIServices.mainBoxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        child: _image != null
            ? Image.file(
                _image!,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/noBookCover.png',
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  //! (SCREEN 2) - BACKGROUND
  static var screen2BG = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/ScreenBG/2ndScreenAddBook.png"),
      fit: BoxFit.cover,
    ),
  );

  //! (SCREEN 2) - DESCIRPTION BOX
  static makeDescriptionTextBox(TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Variables.themePurple,
      ),
      child: TextFormField(
        textAlign: TextAlign.center,
        controller: controller,
        maxLines: 10,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
          labelText: "Write a brief description...",
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          errorBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
          errorStyle: TextStyle(
            fontWeight: FontWeight.bold,
            height: 0.1,
          ),
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

  //! (SCREEN 3) - BACKGROUND
  static var screen3BG = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/ScreenBG/3rdScreenAddBooks.png"),
      fit: BoxFit.cover,
    ),
  );

  //! (SCREEN 3) - MAKE LABEL
  static makeText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Variables.themePurple,
      ),
    );
  }

  //! (SCREEN 3) - DATEPICK CONTAINER DECORATIONS
  static var datePickerDecoration = BoxDecoration(
    color: Color(0xFF4D028A),
    borderRadius: BorderRadius.circular(10),
  );

  //! (SCREEN 3) - CURRENT DATE TEXT
  static currentDateText(var day, month, year) {
    return Text(
      day.toString() + " / " + month.toString() + " / " + year.toString(),
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //! (SCREEN 3) - CONTAINER ICON DATE PICKER
  static var datePickContainerIcon = Icon(
    Icons.keyboard_arrow_down_rounded,
    color: Colors.white,
  );
}
