import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';
import 'package:lottie/lottie.dart';

class AboutUsService {
  //! BACKGROUND
  static var screenBG = BoxDecoration(
    image: DecorationImage(
        image: AssetImage("assets/ScreenBG/AboutUsBG.png"), fit: BoxFit.cover),
  );

  //! GET IN TOUCH BOX DECOR
  static var getInTouchDecor = BoxDecoration(
    color: Variables.themePurple,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [UIServices.mainBoxShadow],
  );

  //!MAKE HEADING TEXT
  static makeHeadingText(String text, double size) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  //! MAKE THE SCROLLING ITEM FOR GET TO KNOW US SECTION
  static Container rowItem(
      String animationAsset, firstLineText, description, double margin) {
    return Container(
      margin: EdgeInsets.only(left: margin),
      child: Column(
        children: [
          Container(
            width: 300,
            height: 300,
            child: Lottie.asset(animationAsset),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              '$firstLineText',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic,
                color: Variables.themePurple,
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
                style:
                    TextStyle(wordSpacing: 3, fontSize: 15, letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! MEET THE TEAM CONTAINER
  static Container meetTheTeamContainer(String imagePath, String personName,
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
                        image: DecorationImage(
                            fit: BoxFit.cover, image: AssetImage(imagePath)),
                        boxShadow: [UIServices.mainBoxShadow]),
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
                                color: Colors.white,
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
                          style: TextStyle(color: Colors.white),
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

  //! MAKE TEXT FIELD
  static makeTextField(TextEditingController controller, String labelText) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
        ),
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
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
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

  //! MAKE MESSAGE TEXTBOX
  static makeMessageTextField(TextEditingController controller, var labelText) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        maxLength: 1500,
        controller: controller,
        maxLines: 10,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          counterStyle: TextStyle(color: Colors.white),
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide(
              color: Colors.white,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.white,
            ),
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
}
