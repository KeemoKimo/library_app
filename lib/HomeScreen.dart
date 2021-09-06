import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:library_app/DatabaseSerivces.dart';
import 'package:library_app/addBook.dart';
import 'package:library_app/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:library_app/myAccount.dart';
import 'package:path/path.dart' as Path;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String id = 'HomeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String? username = '';
  late String? userEmail = loggedInUser.email;
  late String? userUID = loggedInUser.uid;
  late String age = '';
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  File? file;
  late String imageUrl = '';
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
    late String? title = '';
    var drawer2 = Drawer(
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                  image: AssetImage('assets/images/sask.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Stack(
                      children: [
                        Text(
                          '$userEmail',
                          style: TextStyle(
                            fontSize: 20,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black,
                          ),
                        ),
                        Text(
                          '$userEmail',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: const Text('My Account'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAccountPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Edit profile'),
              onTap: () async {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            SafeArea(
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "SET USERNAME...",
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          username = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      padding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                          labelText: "AGE...",
                                          labelStyle:
                                              TextStyle(color: Colors.black),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            borderSide: BorderSide(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          age = value;
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      decoration: BoxDecoration(
                                          color: Colors.yellow[800],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      width: 300,
                                      height: 70,
                                      child: TextButton(
                                        onPressed: () async {
                                          showCupertinoDialog(
                                            context: context,
                                            builder: (_) =>
                                                CupertinoAlertDialog(
                                              title: Text("EDIT PROFILE"),
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
                                                                username!,
                                                                age,
                                                                userEmail!,
                                                                '');
                                                        Navigator.pop(context);
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
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: Divider(
                                        thickness: 1,
                                        height: 1,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      child: Text(
                                        "CURRENT USER : $userEmail",
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: const Text('Favourites'),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addBookPage()),
                );
              },
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: const Text(
                'About Us',
              ),
              onTap: () async {
                print('About Us');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: const Text(
                'Log Out',
              ),
              onTap: () async {
                showCupertinoDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                    title: Text("LOG OUT"),
                    content: Text(
                        "Are you sure you want to log out of $userEmail ?"),
                    actions: [
                      CupertinoButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      CupertinoButton(
                          child: Text(
                            'Log Out',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () async {
                            await auth.signOut();
                            print('Sign out succesful');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          }),
                    ],
                  ),
                );
                // await auth.signOut();
                // print("Signed Out successful");
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()),
                // );
              },
            ),
          ],
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        drawer: drawer2,
        body: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection('books').snapshots(),
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
                    final books = snapshot.data!.docs;

                    List<Card> bookWidgets = [];
                    for (var book in books) {
                      title = (book.data() as Map)['title'];
                      var author = (book.data() as Map)['author'];
                      var owner = (book.data() as Map)['owner'];
                      var bookCoverURL = (book.data() as Map)['imageURL'];
                      var category = (book.data() as Map)['category'];

                      if (owner == userEmail) {
                        final bookWidget = Card(
                          semanticContainer: true,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 100,
                                    height: 140,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(bookCoverURL)),
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                    ),
                                  ),
                                  Container(
                                    width: 230,
                                    //color: Colors.red,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          category.toString(),
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            title.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Text(
                                            (author),
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 15,
                                  )
                                ],
                              ),
                            ],
                          ),
                          //color: Colors.yellowAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          margin: EdgeInsets.all(10),
                        );
                        bookWidgets.add(bookWidget);
                      }
                    }

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 500,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/wallpaper.jpg'),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.red,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                spreadRadius: 8,
                                blurRadius: 8,
                                offset:
                                    Offset(0, 7), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Stack(
                                  children: [
                                    Text(
                                      "We're glad to see you back!",
                                      style: TextStyle(
                                        fontSize: 30,
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 10
                                          ..color = Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "We're glad to see you back!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Stack(
                                    children: [
                                      Text(
                                        "$userEmail",
                                        style: TextStyle(
                                          fontSize: 30,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 10
                                            ..color = Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "$userEmail",
                                        style: TextStyle(
                                          color: Colors.yellow,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'Your Book Shelf',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                        ),
                        Column(
                          children: bookWidgets,
                        )
                      ],
                    );
                    // return Column(
                    //   children: userDatas,
                    // );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
