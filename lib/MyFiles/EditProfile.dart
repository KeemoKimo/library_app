import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';
import 'HomeScreen.dart';
import 'myAccount.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User loggedInUser;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController aboutController = new TextEditingController();

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
    final userSettings =
        ModalRoute.of(context)!.settings.arguments as UserArguments;
    var pickedCountry = userSettings.userLocation;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF5f72be),
            Color(0xFF6e45e1),
            Color(0xFF89d4cf),
            Color(0xFF9921e8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              color: Colors.red,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  UIServices.makeSpace(20),
                  UIServices.makeCustomTextField(
                      usernameController, userSettings.userUserName, false, 0),
                  UIServices.makeSpace(20),
                  UIServices.makeCustomTextField(
                      ageController, userSettings.age, true, 3),
                  UIServices.makeSpace(20),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      maxLength: 1000,
                      controller: aboutController,
                      maxLines: 10,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        counterStyle: TextStyle(
                          color: Colors.white,
                        ),
                        labelText: "${userSettings.userAbout}",
                        labelStyle: TextStyle(
                          color: Colors.white,
                        ),
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
                    ),
                  ),
                  UIServices.makeSpace(20),
                  GestureDetector(
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        onSelect: (Country country) {
                          setState(() => pickedCountry = country.name);
                        },
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black, width: 2),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              '$pickedCountry',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                            child: Icon(
                              Icons.swap_horizontal_circle_sharp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  UIServices.makeSpace(20),
                  Text("Selected Location : $pickedCountry"),
                  Container(
                    child: GestureDetector(
                        child: Text("Hello"),
                        onTap: () async {
                          try {
                            await DatabaseServices(uid: loggedInUser.uid)
                                .updateUserData(
                              usernameController.text,
                              ageController.text,
                              loggedInUser.email!,
                              userSettings.userPFP,
                              userSettings.totalBooks,
                              pickedCountry,
                              aboutController.text,
                              userSettings.userTotalFavourites,
                              userSettings.userCreatedDate,
                              userSettings.userCreatedMonth,
                              userSettings.userCreatedYear,
                              userSettings.isShowLocation,
                              userSettings.isShowAge,
                              userSettings.isShowBook,
                              userSettings.isShowFavourite,
                            );
                            Navigator.pop(context);
                          } catch (e) {
                            print(e.toString());
                          }
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
