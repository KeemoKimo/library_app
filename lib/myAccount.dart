import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({Key? key}) : super(key: key);

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late DatabaseServices dbService;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  late String? userEmail = loggedInUser.email;
  late User loggedInUser;
  late String? profileURL = '';
  late File userProfilePicture;
  late String? userName = '';
  late String? age = '';
  List<int> numForLoopContainer = [0, 1, 2, 3, 5, 6, 7];

  void initState() {
    super.initState();
    getCurrentUser().whenComplete(() {
      setState(() {
        print(loggedInUser.email);
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
    Future pickAndUploadImage() async {
      final ImagePicker _picker = ImagePicker();
      try {
        XFile? image = (await _picker.pickImage(source: ImageSource.gallery));
        print('Image Picking Process Starting');
        await new Future.delayed(const Duration(seconds: 2));
        if (image != null) {
          userProfilePicture = File(image.path);
          print(userProfilePicture);
          print(File(image.path));
          if (userProfilePicture.path != image.path) {
            print('It didnt work sorry');
            Navigator.pop(context);
          } else {
            print('Should be startting to put file in');
            var snapshot = await storage
                .ref()
                .child('userProfiles/$userEmail profile')
                .putFile(userProfilePicture);
            print('file put in!');
            profileURL = await snapshot.ref.getDownloadURL();
          }
        } else {
          print("Please choose a picture");
          return;
        }
        setState(() {
          DatabaseServices(uid: loggedInUser.uid).updateUserPhoto(profileURL!);
          print(profileURL);
        });
      } catch (e) {
        print(e);
      }
    }

    Container customDivider() {
      return Container(
        padding: EdgeInsets.all(20),
        child: Divider(
          height: 1,
          thickness: 1,
          color: Colors.black,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          'MY ACCOUNT',
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Container(
                          color: Colors.red,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                    );
                  }
                  final users = snapshot.data!.docs;
                  for (var user in users) {
                    userName = (user.data() as Map)['userName'];
                    var email = (user.data() as Map)['email'];
                    age = (user.data() as Map)['age'];
                    profileURL = (user.data() as Map)['profileURL'];

                    // if (userEmail == email) {
                    //   final userStructure = Text(
                    //       'Username : $userName , email : $email , age : $age');
                    //   userDatas.add(userStructure);
                    // }
                  }

                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          pickAndUploadImage();
                        },
                        onLongPress: () {
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
                                    border: Border.all(
                                        color: Colors.black, width: 3),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: profileURL == ''
                                          ? NetworkImage(
                                              'https://www.brother.ca/resources/images/no-product-image.png')
                                          : NetworkImage(profileURL!),
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
                            border: Border.all(width: 3, color: Colors.black),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: profileURL == ''
                                  ? NetworkImage(
                                      'https://www.brother.ca/resources/images/no-product-image.png')
                                  : NetworkImage(profileURL!),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 5,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  height: 400,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: "$userName",
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            userName = value;
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: TextFormField(
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            labelText: "$age",
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                          onChanged: (value) {
                                            age = value;
                                          },
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 20),
                                        decoration: BoxDecoration(
                                            color: Colors.purple,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        width: 300,
                                        height: 50,
                                        child: TextButton(
                                          onPressed: () async {
                                            showCupertinoDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CupertinoAlertDialog(
                                                title: Text(
                                                  "EDIT PROFILE",
                                                ),
                                                content: Text(
                                                    "Are you sure you want to edit the content of $userEmail ?"),
                                                actions: [
                                                  CupertinoButton(
                                                      child: Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      }),
                                                  CupertinoButton(
                                                      child: Text(
                                                        'Edit',
                                                        style: TextStyle(
                                                            color: Colors.red),
                                                      ),
                                                      onPressed: () async {
                                                        try {
                                                          await DatabaseServices(
                                                                  uid:
                                                                      loggedInUser
                                                                          .uid)
                                                              .updateUserData(
                                                                  userName!,
                                                                  age!,
                                                                  userEmail!,
                                                                  profileURL!);
                                                          Navigator.pop(
                                                              context);
                                                        } catch (e) {
                                                          print(e.toString());
                                                        }
                                                      }),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "CONFIRM CHANGE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ),
                                      customDivider(),
                                      Text('Signed In as : '),
                                      Text(
                                        userEmail!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      customDivider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Text(
                                userName!,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              Text(
                                userEmail!,
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                      customDivider(),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'My Status : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              margin: EdgeInsets.only(top: 20),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              color: Colors.black,
                              child: Row(
                                children: [
                                  for (var i in numForLoopContainer)
                                    Container(
                                      width: 150,
                                      height: 150,
                                      color: Colors.accents[i],
                                      child: Center(
                                        child: Text(
                                          i.toString(),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
