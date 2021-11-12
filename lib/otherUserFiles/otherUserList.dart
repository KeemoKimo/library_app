import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:library_app/variables.dart';

class OtherUserList extends StatefulWidget {
  const OtherUserList({Key? key}) : super(key: key);

  @override
  _OtherUserListState createState() => _OtherUserListState();
}

class _OtherUserListState extends State<OtherUserList> {
  late var userSnapshot = Variables.firestore.collection('users').get();
  TextEditingController _searchController = TextEditingController();
  List allResult = [], searchedResultList = [];
  late Future resultsLoaded;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchchanged);
    build(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAllUser();
  }

  _onSearchchanged() {
    searchResultList();
  }

//! SHOW ALL THE LIST OF USERS WHEN THE VALUE IS CHANGED IN TEXTFIELD
  searchResultList() {
    var showResult = [];
    if (_searchController.text != "") {
      //have search parameter
      for (var userSnapshot in allResult) {
        var name =
            UserArguments.fromSnapshot(userSnapshot).userUserName.toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResult.add(userSnapshot);
        }
      }
    } else {
      showResult = List.from(allResult);
    }
    setState(() {
      searchedResultList = showResult;
    });
  }

//! GET ALL THE USER FROM FIREBASE AND STORE IT IN A LIST
  getAllUser() async {
    var data = await userSnapshot;
    setState(() {
      allResult = data.docs;
    });
    searchResultList();
    return "Get all user completed!";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: UIServices.makeAppBarTextfield(
            _searchController, "Search user ...", Variables.themePurple),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //! CHECK IF INPUT TEXT USER EXIST
              searchedResultList.length > 0
                  //! IF EXIST = SHOW THE LIST OF ALL USER FOUND
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchedResultList.length,
                      itemBuilder: (context, index) {
                        String userUserName =
                            searchedResultList[index]['userName'];
                        String userPfp =
                            searchedResultList[index]['profileURL'];
                        String userEmail = searchedResultList[index]['email'];
                        String userTotalBooks =
                            searchedResultList[index]['totalBooks'];
                        String userTotalFavourites =
                            searchedResultList[index]['totalFavourites'];
                        String userAge = searchedResultList[index]['age'];
                        String userAbout = searchedResultList[index]['about'];
                        String userLocation =
                            searchedResultList[index]['location'];
                        int userCreatedDate =
                            searchedResultList[index]['createdDate'];
                        int userCreatedMonth =
                            searchedResultList[index]['createdMonth'];
                        int userCreatedYear =
                            searchedResultList[index]['createdYear'];
                        bool isShowLocation =
                            searchedResultList[index]['showLocation'];
                        bool isShowAge = searchedResultList[index]['showAge'];
                        bool isShowBook = searchedResultList[index]['showBook'];
                        bool isShowFavourite =
                            searchedResultList[index]['showFavourite'];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              'otherUserInfo',
                              arguments: UserArguments(
                                userAge,
                                userEmail,
                                userPfp,
                                userTotalBooks,
                                userUserName,
                                userAbout,
                                userTotalFavourites,
                                userLocation,
                                userCreatedDate,
                                userCreatedMonth,
                                userCreatedYear,
                                isShowLocation,
                                isShowAge,
                                isShowBook,
                                isShowFavourite,
                              ),
                            );
                          },
                          child: UserArguments.makeUserListTiles(
                            userPfp,
                            userUserName,
                          ),
                        );
                      },
                    )
                  //! NOT EXIST = SHOW A TEXT
                  : Center(
                      child: Column(
                        children: [
                          UIServices.makeSpace(20),
                          Text(
                            "No user found :(",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
