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
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/createAccountPage.dart';
import 'package:library_app/otherUserFiles/otherUsersBooks.dart';
import 'package:library_app/otherUserFiles/otherUsersFavourites.dart';
import 'package:library_app/otherUserFiles/otherUserInfo.dart';
import 'package:library_app/resetpasswordscreen.dart';
import 'package:library_app/splashscreen.dart';
import 'package:library_app/variables.dart';
import 'MyFiles/HomeScreen.dart';
import 'Services/UIServices.dart';
import 'ScreenService/AuthenticationService.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Library',
      //first route when app start
      initialRoute: 'splashScreen',
      //list of routes that will be included in this project
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
        'splashScreen': (context) => const MainSplashScreen(),
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

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = new TextEditingController(),
      passwordController = new TextEditingController();
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  int selectedIndex = 0;
  bool loading = false;

//! MAIN BUILD METHOD
  @override
  Widget build(BuildContext context) {
    //! LOGIN SCREEN

    var loginScreen = Material(
      type: MaterialType.transparency,
      child: Center(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            children: [
              //!IMAGE FOR LOGIN
              LoginPageService.loginScreenAnimation,
              //!The rest of the login form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    //? EMAIL TEXT BOX
                    LoginPageService.makeAuthenticationTextField(
                        emailController, false, "Enter email...", 350, 0, 20),
                    //? PASSWORD TEXT BOX / ICON
                    Row(
                      children: [
                        LoginPageService.makeAuthenticationTextField(
                            passwordController,
                            isObscure,
                            "Enter Password...",
                            310,
                            20,
                            0),
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
                          child: LoginPageService.revealPassword,
                        ),
                      ],
                    ),
                    UIServices.makeSpace(50),
                    //? LOG IN BUTTON
                    Container(
                      width: double.infinity,
                      height: 50,
                      margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      decoration: LoginPageService.btnLoginProperties,
                      child: TextButton(
                        child: LoginPageService.btnLogin,
                        onPressed: () async {
                          try {
                            if (emailController.text == "" ||
                                passwordController.text == "") {
                              LoginPageService.showEmptyTextBoxPopup(context);
                            } else if (emailController.text.contains('@') ==
                                false) {
                              LoginPageService.showProperEmailPopup(context);
                            } else {
                              setState(() => loading = true);
                              await auth.signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text);
                              LoginPageService.goHomeScreen(context);
                            }
                          } on FirebaseAuthException catch (e) {
                            setState(() => loading = false);
                            LoginPageService.catchExceptions(e, context);
                          } catch (e) {
                            LoginPageService.showDefaultErrorPopup(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              //! FORGOT PASSWORD
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ResetScreen()),
                  );
                },
                child: Text(
                  "Forgot Password ?",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //! REGISTER SCREEN INSTANCE
    var registerScreen = RegisterAccount();
    var screens = [loginScreen, registerScreen];
    return loading == true
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: screens[selectedIndex],
            bottomNavigationBar: CurvedNavigationBar(
              color: Variables.themePurple,
              buttonBackgroundColor: Colors.transparent,
              backgroundColor: (selectedIndex == 0)
                  ? Colors.transparent
                  : Colors.transparent,
              height: 50,
              items: LoginPageService.bottomNavBarProperties,
              animationDuration: Duration(milliseconds: 700),
              animationCurve: Curves.easeInOutCubic,
              onTap: (index) {
                setState(
                  () {
                    selectedIndex = index;
                  },
                );
              },
            ),
          );
  }
}
