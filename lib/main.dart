import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:library_app/InfoPages/BookInfo.dart';
import 'package:library_app/InfoPages/HotBookInfo.dart';
import 'package:library_app/MyFiles/EditBook/EditBookCover.dart';
import 'package:library_app/InfoPages/aboutUs.dart';
import 'package:library_app/MyFiles/EditBook/EditBookInfo.dart';
import 'package:library_app/MyFiles/EditProfile.dart';
import 'package:library_app/ScreenService/AuthenticationService.dart';
import 'package:library_app/createAccountPage.dart';
import 'package:library_app/otherUserFiles/otherUsersBooks.dart';
import 'package:library_app/otherUserFiles/otherUsersFavourites.dart';
import 'package:library_app/otherUserFiles/otherUserInfo.dart';
import 'package:page_transition/page_transition.dart';
import 'MyFiles/HomeScreen.dart';
import 'Services/UIServices.dart';

//todo RUN APP
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      //first route when app start
      initialRoute: 'home',
      //list of route that will be included in this project
      routes: {
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
      },
      theme: ThemeData(primaryColor: Colors.blue, fontFamily: 'Lato'),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

//todo MAIN DESIGN CLASS
class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  int selectedIndex = 0;

//! MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //! LOGIN SCREEN
    var loginScreen = Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //!Authentication label
          Container(
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
          ),
          UIServices.makeSpace(130),
          //!The rest of the login form
          Form(
            key: _formKey,
            child: Column(
              children: [
                //? EMAIL TEXT BOX
                UIServices.makeCustomTextField(
                    emailController, "Enter Email...", false, 0),
                //? PASSWORD TEXT BOX / ICON
                Row(
                  children: [
                    LoginPageService.makePasswordTextField(
                        passwordController, isObscure),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            if (isObscure == true) {
                              isObscure = false;
                            } else {
                              isObscure = true;
                            }
                          },
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20, left: 20),
                        width: 30,
                        height: 30,
                        child: Image(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/eye.png'),
                        ),
                      ),
                    ),
                  ],
                ),
                UIServices.makeSpace(90),
                //? LOG IN BUTTON
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextButton(
                    child: Container(
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          color: Color(0xFF9E2B55),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        if (emailController.text == "" ||
                            passwordController.text == "") {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UIServices.showPopup(
                                  'Please enter in your email and password!',
                                  'assets/images/error.png',
                                  true);
                            },
                          );
                        } else if (emailController.text.contains('@') ==
                            false) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return UIServices.showPopup(
                                  'Please enter a proper email',
                                  'assets/images/error.png',
                                  true);
                            },
                          );
                        } else {
                          await auth.signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                          //this line is to make user go second screen
                          Navigator.push(
                            context,
                            PageTransition(
                              child: HomeScreen(),
                              type: PageTransitionType.rightToLeftWithFade,
                              duration: Duration(seconds: 1),
                            ),
                          );
                        }
                      } on FirebaseAuthException catch (e) {
                        LoginPageService.catchExceptions(e, context);
                      } catch (e) {
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
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
    //! REGISTER SCREEN INSTANCE
    var registerScreen = RegisterAccount();
    var screens = [loginScreen, registerScreen];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            Color(0xFF3c1053),
            Color(0xFFF00000),
            Color(0xFF2657eb),
            Color(0xFF1565C0),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: screens[selectedIndex],
        bottomNavigationBar: CurvedNavigationBar(
          buttonBackgroundColor: Colors.transparent,
          backgroundColor:
              (selectedIndex == 0) ? Colors.transparent : Color(0xFFAF0022),
          height: 50,
          items: LoginPageService.bottomNavBarProperties,
          animationDuration: Duration(milliseconds: 400),
          animationCurve: Curves.easeInOut,
          onTap: (index) {
            setState(
              () {
                selectedIndex = index;
              },
            );
          },
        ),
      ),
    );
  }
}
