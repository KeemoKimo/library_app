import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';

class OtherUserInfo extends StatefulWidget {
  const OtherUserInfo({Key? key}) : super(key: key);

  @override
  _OtherUserInfoState createState() => _OtherUserInfoState();
}

class _OtherUserInfoState extends State<OtherUserInfo> {
  late User loggedInUser;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        build(context);
      });
    });
  }

  getCurrentUser() async {
    try {
      final user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userID = ModalRoute.of(context)!.settings.arguments as UserArguments;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFc31432),
            Color(0xFF044B7F),
            Color(0xFFf12711),
            Color(0xFF240b36),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  UIServices.makeSpace(40),
                  //! USER PROFILE PHOTO
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 10,
                            child: Container(
                              width: 400,
                              height: 400,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border:
                                    Border.all(color: Colors.white, width: 5),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: userID.userPFP == ''
                                      ? NetworkImage(
                                          'https://www.brother.ca/resources/images/no-product-image.png')
                                      : NetworkImage(userID.userPFP),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.white),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: userID.userPFP == ''
                              ? NetworkImage(
                                  'https://www.brother.ca/resources/images/no-product-image.png')
                              : NetworkImage(userID.userPFP),
                        ),
                      ),
                    ),
                  ),
                  //! USER NAME AND EMAIL
                  UIServices.makeSpace(10),
                  Text(
                    userID.userUserName,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  UIServices.makeSpace(10),
                  Text(
                    userID.email,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontStyle: FontStyle.italic),
                  ),
                  UIServices.customDivider(Colors.white),
                  //! USER INFORMATION
                  UIServices.customAlignedText(Alignment.centerLeft,
                      "More about ${userID.userUserName}", Colors.white),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          userID.userAbout,
                          style: TextStyle(
                              wordSpacing: 2,
                              letterSpacing: 1,
                              color: Colors.white,
                              height: 1.5),
                        ),
                        UIServices.makeSpace(20),
                        UIServices.makeRowItem(
                            Icons.location_city,
                            "User Location",
                            userID.isShowLocation == true
                                ? "${userID.userLocation}"
                                : "Location Disclosed!",
                            Colors.white),
                        UIServices.makeSpace(20),
                        UIServices.makeRowItem(
                            CupertinoIcons.calendar,
                            "Created Date",
                            "${userID.userCreatedDate} / ${userID.userCreatedMonth} / ${userID.userCreatedYear}",
                            Colors.white),
                        UIServices.makeSpace(20),
                        UIServices.makeRowItem(
                            CupertinoIcons.person_2_fill,
                            "User Age",
                            userID.isShowAge == true
                                ? "${userID.age} years old"
                                : "Private",
                            Colors.white),
                      ],
                    ),
                  ),

                  //! USER STATISTICS
                  UIServices.customAlignedText(
                      Alignment.centerLeft, "Statistic", Colors.white),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        UIServices.makeRowItem(
                            CupertinoIcons.book_fill,
                            "Total Books",
                            "${userID.totalBooks}",
                            Colors.white),
                        UIServices.makeSpace(20),
                        UIServices.makeRowItem(
                            CupertinoIcons.heart_fill,
                            "Total Favourites",
                            "${userID.userTotalFavourites}",
                            Colors.white),
                      ],
                    ),
                  ),
                  UIServices.customDivider(Colors.white),
                  //! CHECK IF USER SHOW BOOKS & FAVOURITES
                  userID.isShowBook == true
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'otherUserBooks',
                              arguments: UserArguments(
                                userID.age,
                                userID.email,
                                userID.userPFP,
                                userID.totalBooks,
                                userID.userUserName,
                                userID.userAbout,
                                userID.userTotalFavourites,
                                userID.userLocation,
                                userID.userCreatedDate,
                                userID.userCreatedMonth,
                                userID.userCreatedYear,
                                userID.isShowLocation,
                                userID.isShowAge,
                                userID.isShowBook,
                                userID.isShowFavourite,
                              ),
                            );
                          },
                          child: UIServices.customCard(
                            'All Books',
                            Icons.menu_book_rounded,
                            Icons.arrow_forward_ios_rounded,
                            10,
                            Color(0xFF331832),
                            Color(0xFF331832),
                          ),
                        )
                      : UIServices.makeSpace(0),
                  userID.isShowFavourite == true
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'otherUserFavourites',
                              arguments: UserArguments(
                                userID.age,
                                userID.email,
                                userID.userPFP,
                                userID.totalBooks,
                                userID.userUserName,
                                userID.userAbout,
                                userID.userTotalFavourites,
                                userID.userLocation,
                                userID.userCreatedDate,
                                userID.userCreatedMonth,
                                userID.userCreatedYear,
                                userID.isShowLocation,
                                userID.isShowAge,
                                userID.isShowBook,
                                userID.isShowFavourite,
                              ),
                            );
                            //print('${userID.email} favourites books!');
                          },
                          child: UIServices.customCard(
                            'All Favourite',
                            CupertinoIcons.star_circle_fill,
                            Icons.arrow_forward_ios_rounded,
                            10,
                            Color(0xFF331832),
                            Color(0xFF331832),
                          ),
                        )
                      : UIServices.makeSpace(0),
                  UIServices.customDivider(Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
