import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/ScreenService/HomeScreenService.dart';
import 'package:library_app/ScreenService/LoadingScreens/changingPic.dart';
import 'package:library_app/ScreenService/MyAccountService.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/InfoPages/allBooks.dart';
import 'package:library_app/InfoPages/all_favourites.dart';
import 'package:library_app/variables.dart';
import '../Services/UIServices.dart';

class MyAccountPage extends StatefulWidget {
  final User loggedInUser;
  const MyAccountPage({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _MyAccountPageState createState() =>
      _MyAccountPageState(loggedInUser: loggedInUser);
}

class _MyAccountPageState extends State<MyAccountPage> {
  late User loggedInUser;
  _MyAccountPageState({required this.loggedInUser});
  late File userProfilePicture;
  late String? userEmail = loggedInUser.email, userUID = loggedInUser.uid;
  late String? profileURL = '',
      userName = '',
      age = '',
      totalBooks = '',
      totalFavourites = '',
      currentLocation = '',
      about = '';
  late int? createdDateYear = loggedInUser.metadata.creationTime!.year,
      createdDateMonth = loggedInUser.metadata.creationTime!.month,
      createdDateDate = loggedInUser.metadata.creationTime!.day;
  bool _switchValueLocation = false,
      _switchValueAge = false,
      _switchValueBooks = false,
      _switchValueFavourite = false;
  bool loading = false;

  void initState() {
    super.initState();
    build(context);
  }

  @override
  Widget build(BuildContext context) {
    var mainBody = Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Variables.themePurple,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: StreamBuilder<QuerySnapshot>(
            stream: Variables.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              //!CHECK IF HAVE DATA OR NOT
              if (!snapshot.hasData) {
                return HomeScreenService.loadingIndicator;
              }
              //! LOOP TO GET ALL USER DATA
              final users = snapshot.data!.docs;
              for (var user in users) {
                var email = (user.data() as Map)['email'];
                MyAccountService.countBooks(loggedInUser, totalBooks);
                MyAccountService.countFavourites(loggedInUser, totalFavourites);
                //! CHECK IF LOGGED IN USER EMAIL IS EQUAL TO EMAIL FROM DATABASE
                if (userEmail == email) {
                  profileURL = (user.data() as Map)['profileURL'];
                  userName = (user.data() as Map)['userName'];
                  age = (user.data() as Map)['age'];
                  totalBooks = (user.data() as Map)['totalBooks'];
                  totalFavourites = (user.data() as Map)['totalFavourites'];
                  currentLocation = (user.data() as Map)['location'];
                  about = (user.data() as Map)['about'];
                  _switchValueLocation = (user.data() as Map)['showLocation'];
                  _switchValueAge = (user.data() as Map)['showAge'];
                  _switchValueBooks = (user.data() as Map)['showBook'];
                  _switchValueFavourite = (user.data() as Map)['showFavourite'];
                }
              }

              return Column(
                children: [
                  //! UPLOAD AND DISPLAY PFP
                  Container(
                    height: 450,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //! TOP ROW
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 20),
                              child: MyAccountService.myProfileLabel,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 20),
                              child: Hero(
                                tag: 'EditPage',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        'editProfile',
                                        arguments: UserArguments(
                                          age!,
                                          userEmail!,
                                          profileURL!,
                                          totalBooks!,
                                          userName!,
                                          about!,
                                          totalFavourites!,
                                          currentLocation!,
                                          createdDateDate!,
                                          createdDateMonth!,
                                          createdDateYear!,
                                          _switchValueLocation,
                                          _switchValueAge,
                                          _switchValueBooks,
                                          _switchValueFavourite,
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.settings,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () => pickAndUploadImage(),
                                onLongPress: () =>
                                    MyAccountService.showProfilePicturePopup(
                                        context, profileURL!),
                                child: MyAccountService
                                    .showMyProfilePicRoundedContainer(
                                        profileURL!),
                              ),
                              MyAccountService.add_a_photo_icon,
                            ],
                          ),
                        ),
                        UIServices.makeSpace(20),
                        MyAccountService.showUsernameText(userName!),
                        UIServices.makeSpace(10),
                        MyAccountService.showEmailText(userEmail!),
                      ],
                    ),
                  ),
                  //! EVERYTHING BELOW USER PROFILE
                  Container(
                    decoration: MyAccountService.infoContainerDecoration,
                    child: Column(
                      children: [
                        //!YOUR INFORMATION SECTION
                        UIServices.makeSpace(40),
                        UIServices.customAlignedText(Alignment.centerLeft,
                            "Your Information", Colors.black),
                        UIServices.makeSpace(20),
                        MyAccountService.makeYourInfo(
                            UIServices.makeSpace(40),
                            age,
                            createdDateDate,
                            createdDateMonth,
                            createdDateYear,
                            about,
                            currentLocation),
                        //!PRIVACY SETTINGS SECTION
                        UIServices.makeSpace(20),
                        UIServices.customAlignedText(Alignment.centerLeft,
                            "Privacy Settings", Colors.black),
                        UIServices.makeSpace(40),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xFF4D028A),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [UIServices.mainBoxShadow],
                          ),
                          child: Column(
                            children: [
                              makeToggleContainer(
                                  context,
                                  'assets/images/location.png',
                                  'Show Location:',
                                  'Location',
                                  20,
                                  _switchValueLocation),
                              makeToggleContainer(
                                  context,
                                  'assets/images/age.png',
                                  'Show age:',
                                  'Age',
                                  50,
                                  _switchValueAge),
                              makeToggleContainer(
                                  context,
                                  'assets/images/booksIcon.png',
                                  'Show your books:',
                                  'Books',
                                  0,
                                  _switchValueBooks),
                              makeToggleContainer(
                                  context,
                                  'assets/images/heart.png',
                                  'Show Favourites:',
                                  'Favourites',
                                  3,
                                  _switchValueFavourite),
                            ],
                          ),
                        ),
                        //!CONTENTS SECTION
                        UIServices.makeSpace(40),
                        UIServices.customAlignedText(
                            Alignment.centerLeft, "Contents", Colors.black),
                        UIServices.makeSpace(40),
                        MyAccountService.makeBooksContents(
                            context,
                            AllBooksPage(loggedInUser: loggedInUser),
                            Icons.book,
                            CupertinoIcons.forward,
                            "My Books"),
                        UIServices.makeSpace(20),
                        MyAccountService.makeBooksContents(
                          context,
                          AllFavouritesPage(loggedInUser: loggedInUser),
                          Icons.favorite,
                          CupertinoIcons.forward,
                          "Favourites",
                        ),
                        UIServices.makeSpace(20),
                        //!STATISTICS SECTION
                        UIServices.makeSpace(20),
                        UIServices.customAlignedText(Alignment.centerLeft,
                            "Your Statistics", Colors.black),
                        UIServices.makeSpace(20),
                        MyAccountService.makeYourStatistic(
                            totalBooks, totalFavourites),
                        //!ENDING
                        UIServices.customDivider(Colors.black),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
    return loading == true ? SwitchingPhotoLoading() : mainBody;
  }

  //!FUNCTION FOR MAKING THE CONTAINER TO TOGGLE PRIVACY SETTINGS
  Container makeToggleContainer(
      BuildContext context,
      String imagePath,
      String instructionText,
      String details,
      double marginValue,
      bool switchValue) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(right: 20, bottom: 20, top: 20),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(left: 40),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imagePath),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 30),
            child: Text(
              instructionText,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Container(
              margin: EdgeInsets.only(left: marginValue),
              child: CupertinoSwitch(
                activeColor: Colors.lightGreen,
                trackColor: Colors.red,
                thumbColor: Colors.white,
                value: switchValue,
                onChanged: (value) {
                  setState(
                    () {
                      switchValue = value;
                      print(switchValue);
                      if (details == "Location") {
                        DatabaseServices(uid: loggedInUser.uid)
                            .updateLocationPrivacyStatus(switchValue);
                      } else if (details == "Age") {
                        DatabaseServices(uid: loggedInUser.uid)
                            .updateAgePrivacyStatus(switchValue);
                      } else if (details == "Books") {
                        DatabaseServices(uid: loggedInUser.uid)
                            .updateBooksPrivacyStatus(switchValue);
                      } else if (details == "Favourites") {
                        DatabaseServices(uid: loggedInUser.uid)
                            .updateFavouritePrivacyStatus(switchValue);
                      }
                    },
                  );
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  var snackBar = SnackBar(
                    content: switchValue == true
                        ? Text('$details switched on!')
                        : Text('$details switched off!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //! FUNCTION FOR SELECTING AND UPLOADING IMAGE
  Future pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    try {
      XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
      print('Image Picking Process Starting');
      if (image != null) {
        setState(() => loading = true);
        userProfilePicture = File(image.path);
        print(userProfilePicture);
        print(File(image.path));
        if (userProfilePicture.path != image.path) {
          print('It didnt work sorry');
          setState(() => loading = false);
          Navigator.pop(context);
        } else {
          print('Should be startting to put file in');
          var snapshot = await Variables.storage
              .ref()
              .child('userProfiles/$userEmail profile')
              .putFile(userProfilePicture);
          print('file put in!');
          profileURL = await snapshot.ref.getDownloadURL();
        }
      } else {
        print("Please choose a picture");
        setState(() => loading = false);
        return;
      }
      setState(() {
        DatabaseServices(uid: loggedInUser.uid).updateUserPhoto(profileURL!);
        print(profileURL);
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      print(e);
    }
  }
}
