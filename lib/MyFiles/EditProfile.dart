import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ScreenService/EditProfileService.dart';
import 'package:library_app/ScreenService/Loading.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/DatabaseSerivces.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User loggedInUser;
  bool loading = false;

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

    var mainBody = Container(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      decoration: EditProfileService.editProfileBG,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              UIServices.makeSpace(40),
              EditProfileService.makeCustomAlignedText("👨 Your Information :"),
              UIServices.makeSpace(40),
              //! Username text field
              UIServices.makeCustomTextField(
                  usernameController, "Username", context, false, 1),
              UIServices.makeSpace(20),
              //! Age text field
              UIServices.makeCustomTextField(
                  ageController, "Your age", context, false, 2),
              UIServices.makeSpace(20),
              //! About me text field
              EditProfileService.makeAboutMeTextbox(aboutController),
              UIServices.customDivider(Variables.themePurple),
              //! Country picker container
              UIServices.makeSpace(20),
              EditProfileService.makeCustomAlignedText("📍 Location :"),
              UIServices.makeSpace(40),
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
                    child: EditProfileService.makeCountryPicker(pickedCountry),
                  );
                },
              ),
              UIServices.makeSpace(40),
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
                setState(() => loading = true);
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
                setState(() => loading = false);
                EditProfileService.showErrorPopup(context, e);
              }
            },
            child: const Icon(Icons.edit),
            backgroundColor: Colors.green,
          ),
        ),
      ),
    );

    return loading == true ? Loading() : mainBody;
  }
}
