import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:library_app/ScreenService/CategoryService.dart';
import 'package:library_app/categoryPages/biography.dart';
import 'package:library_app/categoryPages/comic.dart';
import 'package:library_app/categoryPages/design.dart';
import 'package:library_app/categoryPages/fiction.dart';
import 'package:library_app/categoryPages/historical.dart';
import 'package:library_app/categoryPages/non_fiction.dart';
import 'package:library_app/categoryPages/philosophy.dart';
import 'package:library_app/categoryPages/sci_fi.dart';
import 'package:page_transition/page_transition.dart';

class SelectCategoryPage extends StatefulWidget {
  final User loggedInUser;
  const SelectCategoryPage({Key? key, required this.loggedInUser})
      : super(key: key);

  @override
  _SelectCategoryPageState createState() =>
      _SelectCategoryPageState(loggedInUser: loggedInUser);
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  late User loggedInUser;
  _SelectCategoryPageState({required this.loggedInUser});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              //! FICTIONAL
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      fictionPage(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/fictional.jpg',
                      'Ficitional',
                      Alignment.topCenter)),
              //! NON FICTION
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      Non_Fiction_Page(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/anneFrank.jpg',
                      'Non-Fictional',
                      Alignment.bottomCenter)),
              //! HISTORICAL
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      HistoricalPage(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/wingedHussars.jpg',
                      'Historical',
                      Alignment.topCenter)),
              //! PHILOSOPHY
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      PhilosophyPage(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/plato_philosopher.jpg',
                      'Philosophy',
                      Alignment.topCenter)),
              //! SCI FI
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      SciFiPage(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/sci_fi.jpg',
                      'Sci-Fi',
                      Alignment.topCenter)),
              //! COMIC
              GestureDetector(
                  onTap: () {
                    CategoryService.goNewScreen(
                      context,
                      ComicPage(loggedInUser: loggedInUser),
                    );
                  },
                  child: CategoryService.makeCategoryContainer(
                      'assets/images/comics.jpg',
                      'Comic',
                      Alignment.topCenter)),
              //! BIOGRAPHY
              GestureDetector(
                onTap: () {
                  CategoryService.goNewScreen(
                    context,
                    BiographyPage(loggedInUser: loggedInUser),
                  );
                },
                child: CategoryService.makeCategoryContainer(
                    'assets/images/sittingBull.jpg',
                    'Biography',
                    Alignment.topCenter),
              ),
              //! DESIGN
              GestureDetector(
                onTap: () {
                  CategoryService.goNewScreen(
                      context, DesignPage(loggedInUser: loggedInUser));
                },
                child: CategoryService.makeCategoryContainer(
                    'assets/images/design.jpg', 'Design', Alignment.center),
              )
            ],
          ),
        ),
      ),
    );
  }
}
