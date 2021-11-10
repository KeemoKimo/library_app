import 'package:flutter/material.dart';
import 'package:library_app/Services/UIServices.dart';

//! MANAGES THE FUNCTIONS / UI FOR LOGIN
class LoginPageService {
  static var routes = {
    'home': (context) => const LoginPage(),
    'main': (context) => const HomeScreen(),
    'bookInfo': (context) => const BookInfo(),
    'otherUserInfo': (context) => const OtherUserInfo(),
    'otherUserBooks': (context) => const OtherUserBooks(),
    'otherUserFavourites': (context) => const OtherUsersFavourites(),
    'editBookCover': (context) => const EditBook(),
    'editBookInfo': (context) => const EditBookInfo(),
    'aboutUs': (context) => const AboutUs(),
    'editProfile': (context) => const EditProfile(),
    'HotBookInfo': (context) => const HotBooksInfo(),
  };

  //! FUNCITON TO MAKE THE PASSWORD TEXTBOX
  static makePasswordTextField(var controller, isObscure) {
    return Container(
      width: 310,
      height: 60,
      margin: EdgeInsets.only(top: 20, left: 20),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        obscureText: isObscure,
        decoration: InputDecoration(
          hintText: "Enter Password...",
          hintStyle: TextStyle(color: Colors.white),
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
              color: Colors.blue,
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
    margin: EdgeInsets.only(left: 50, top: 100),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Let's Sign you in!",
        style: TextStyle(
          color: Colors.white,
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  //! REVEAL PASSWORD IMAGE
  static var revealPassword = Container(
    margin: EdgeInsets.only(top: 20, left: 20),
    width: 30,
    height: 30,
    child: Image(
      fit: BoxFit.cover,
      image: AssetImage('assets/images/eye.png'),
    ),
  );

  //! TEXT BUTTON LOGIN
  static var btnLogin = Container(
    child: Text(
      'LOGIN',
      style: TextStyle(
        color: Color(0xFF9E2B55),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );

  //! MAIN BACKGROUND GRADIENT
  static var bgGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        Color(0xFF3c1053),
        Color(0xFFF00000),
        Color(0xFF2657eb),
        Color(0xFF834d9b),
      ],
    ),
  );

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
  //! MAIN BACKGROUND COLOR GRADIENT
  static var bgGradient = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF833ab4),
        Color(0xFF3F5EFB),
        Color(0xFF41295a),
        Color(0xFFF00000),
      ],
    ),
  );

  //! REGISTRATION LABEL
  static var registerLabel = Container(
    margin: EdgeInsets.only(left: 50, top: 100),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Create an Account!",
        style: TextStyle(
          color: Colors.white,
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
      color: Color(0xFF55224F),
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  );

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

  //! FUNCTION TO MAKE TEXTFIELDS
  static Container makeTextField(double width, String hintText,
      TextEditingController textEditingController) {
    return Container(
      width: width,
      height: 50,
      child: TextFormField(
        controller: textEditingController,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
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
}