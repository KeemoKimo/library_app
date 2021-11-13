import 'package:flutter/material.dart';
import 'package:library_app/MyFiles/HomeScreen.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

//! MANAGES THE FUNCTIONS / UI FOR LOGIN
class LoginPageService {
  //! ANIMATION IMAGE FOR THE LOGIN SCREEN
  static var loginScreenAnimation = Container(
    width: 200,
    height: 200,
    child: Lottie.asset("assets/Animations/loginAnimation.json"),
  );

  //! PROPERTIES FOR BOTTOM NAVIGATIONAL BAR
  static var bottomNavBarProperties = <Widget>[
    Icon(
      Icons.login,
      color: Colors.black,
      size: 20,
    ),
    Icon(
      Icons.person_add,
      color: Colors.black,
      size: 20,
    ),
  ];

  //! LOGIN LABEL
  static var signInLabel = Container(
    padding: EdgeInsets.all(15),
    child: Center(
      child: Text(
        "Sign In!",
        style: TextStyle(
          color: Color(0xFF4D028A),
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  //! REVEAL PASSWORD IMAGE
  static var revealPassword = Container(
    margin: EdgeInsets.only(top: 20, left: 10),
    width: 30,
    height: 30,
    child: Icon(
      Icons.remove_red_eye,
      color: Color(0xFF4D028A),
    ),
  );

  //! TEXT BUTTON LOGIN
  static var btnLogin = Container(
    child: Text(
      'LOGIN',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );

//! BTN LOGIN PROPERTIES
  static var btnLoginProperties = BoxDecoration(
    color: Color(0xFF4D028A),
    borderRadius: BorderRadius.circular(15),
    boxShadow: [UIServices.mainBoxShadow],
  );

  //! GO TO HOME SCREEN AFTER LOGIN BTN PRESSED
  static goHomeScreen(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        child: HomeScreen(),
        type: PageTransitionType.leftToRightWithFade,
        duration: Duration(seconds: 1),
      ),
    );
  }

  //! ERROR POPUPS
  static showEmptyTextBoxPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup(
            'Please enter in all the fields!', 'assets/images/error.png', true);
      },
    );
  }

  static showProperEmailPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup(
            'Please enter a proper email', 'assets/images/error.png', true);
      },
    );
  }

  static showDefaultErrorPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup('Something went wrong, please try again!',
            'assets/images/error.png', true);
      },
    );
  }

  //! FUNCITON TO MAKE THE TEXTBOX
  static makeAuthenticationTextField(var controller, isObscure, hintText,
      double width, double mrgLeft, double mrgRight) {
    return Container(
      width: width,
      height: 60,
      margin: EdgeInsets.only(top: 20, left: mrgLeft, right: mrgRight),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Variables.themePurple,
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
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

//! TEXT BUTTON FORGOT PASSWORD
  static makeForgotPassword(BuildContext context, var screen) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(
        "Forgot Password ?",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  //! CATCH EXCEPTIONS FROM LOGIN
  static catchExceptions(var e, context) {
    try {
      switch (e.code) {
        case "invalid-email":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup('This email does not exists!',
                  'assets/images/error.png', true);
            },
          );
          break;
        case "wrong-password":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'Incorrect password!', 'assets/images/error.png', true);
            },
          );
          break;
        case "user-not-found":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup('User not found, please create one!',
                  'assets/images/error.png', true);
            },
          );
          break;
        case "user-disabled":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup('This account has been disabled!',
                  'assets/images/error.png', true);
            },
          );
          break;
        case "too-many-requests":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'There is too many request! Please slow down!',
                  'assets/images/error.png',
                  true);
            },
          );
          break;
        case "operation-not-allowed":
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'This operation is not allowed at the current moment!',
                  'assets/images/error.png',
                  true);
            },
          );
          break;
        default:
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'Something went wrong, please try again!',
                  'assets/images/error.png',
                  true);
            },
          );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UIServices.showPopup('Something went wrong, please try again!',
              'assets/images/error.png', true);
        },
      );
    }
  }
}

//! MANAGES THE FUNCTIONS / UI FOR REGISTER
class RegisterPageService {
  //! REGISTRATION LABEL
  static var registerLabel = Container(
    padding: EdgeInsets.all(15),
    margin: EdgeInsets.only(left: 130),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Sign Up",
        style: TextStyle(
          color: Color(0xFF4D028A),
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  //! REGISTER BUTTON
  static var btnRegister = Text(
    'REGISTER !',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  //! RESET PASSWORD BUTTON (RESET SCREEN)
  static var btnSendRequest = Text(
    'SEND REQUEST',
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

  //! MAKE POPUP FOR USERNAME ERROR
  static makeUsernameErrorPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup(
            "Please enter username that is less than 20 characters!",
            "assets/images/error.png",
            true);
      },
    );
  }

  //! CATCH ANY EXCEPTIONS
  static catchExceptions(var e, context) {
    try {
      switch (e.code) {
        case 'weak-password':
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'Create a password with more than 6 characters!',
                  'assets/images/error.png',
                  true);
            },
          );
          break;
        case 'missing-email':
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup('Enter in your email to create!',
                  'assets/images/error.png', true);
            },
          );
          break;
        case 'email-already-in-use':
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'This user already exists! Please make a unique one!',
                  'assets/images/error.png',
                  true);
            },
          );
          break;
        default:
          print(e.code);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return UIServices.showPopup(
                  'The provided credintial could not be created!',
                  'assets/images/error.png',
                  true);
            },
          );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UIServices.showPopup(
              'The provided credintial could not be created!',
              'assets/images/error.png',
              true);
        },
      );
    }
  }
}

//! MANAGE THE FUNCTION / UI FOR RESET PASSWORD and VERIFY EMAIL PAGE
class ResetAndVerifyService {
  //! POPUP SHOWING USER THAT THE REQUEST IS SENT
  static showSentRequestDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return UIServices.showPopup("Request sent! Please check your email.",
            "assets/images/success.png", false);
      },
    );
  }

  //! TEXT FOR RESET PASSWORD
  static var resetPassText = Text(
    "Reset your password",
    style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Variables.themePurple,
        fontSize: 30),
  );

  //! RESET PASSWORD BACKGROUND
  static var resetPassBg = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/ScreenBG/ResetPasswordBG.png"),
      fit: BoxFit.cover,
    ),
  );

//! VERIFY EMAIL - ANIMATION
  static var verifyAnimation = Container(
    width: 300,
    height: 300,
    child: Lottie.asset("assets/Animations/verifyEmail.json"),
  );

//! VERIFY EMAIL - TEXT
  static verifyEmailText(String text) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
    );
  }

//! VERIFY EMAIL - BUTTON
  static makeVerifyButton(BuildContext context) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
          color: Variables.themePurple,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [UIServices.mainBoxShadow]),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
        child: Text(
          "Skip Verification",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

//! VERIFY EMAIL - BACKGROUND
  static var verifyEmailBg = BoxDecoration(
    image: DecorationImage(
      image: AssetImage("assets/ScreenBG/VerifyEmailBG.png"),
      fit: BoxFit.cover,
    ),
  );
}
