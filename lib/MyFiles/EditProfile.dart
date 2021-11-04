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
    TextEditingController usernameController = new TextEditingController();
    TextEditingController ageController = new TextEditingController();
    TextEditingController aboutController = new TextEditingController();
    usernameController.text = userSettings.userUserName;
    ageController.text = userSettings.age;
    aboutController.text = userSettings.userAbout;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFb92b27),
            Color(0xFFc31432),
            Color(0xFF333399),
            Color(0xFFa71d31),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    UIServices.makeSpace(20),
                    //! Username text field
                    UIServices.makeCustomTextField(
                        usernameController, "Username", false, 0),
                    UIServices.makeSpace(20),
                    //! Age text field
                    UIServices.makeCustomTextField(
                        ageController, "Your age", true, 3),
                    UIServices.makeSpace(20),
                    //! About me text field
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
                          labelText: "About me",
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
                    //! Country picker container
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My Location :",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    UIServices.makeSpace(20),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return GestureDetector(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              onSelect: (Country country) {
                                setState(() => pickedCountry = country.name);
                                print(pickedCountry);
                              },
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: Colors.black, width: 1),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    '$pickedCountry',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFDB4048),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(right: 20),
                                  child: Icon(
                                    Icons.swap_horizontal_circle_sharp,
                                    color: Color(0xFFDB4048),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    UIServices.makeSpace(30),
                  ],
                ),
              ),
            ],
          ),
        ),
        //!FAB EDIT
        floatingActionButton: Material(
          type: MaterialType.transparency,
          child: FloatingActionButton(
            heroTag: 'EditPage',
            onPressed: () async {
              try {
                await DatabaseServices(uid: loggedInUser.uid).updateUserData(
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
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'Profile Editted Successful!',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UIServices.showPopup(
                        e.toString(), 'assets/images/error.png', true);
                  },
                );
              }
            },
            child: const Icon(Icons.edit),
            backgroundColor: Color(0xFFc31432),
          ),
        ),
      ),
    );
  }
}
