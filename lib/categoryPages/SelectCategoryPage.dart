import 'package:flutter/material.dart';
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
  const SelectCategoryPage({Key? key}) : super(key: key);

  @override
  _SelectCategoryPageState createState() => _SelectCategoryPageState();
}

Container makeCategoryContainer(
    String bgImgPath, String categoryName, Alignment bgImgAlignment) {
  return Container(
    width: double.infinity,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.red,
      image: DecorationImage(
        image: AssetImage(bgImgPath),
        fit: BoxFit.cover,
        alignment: bgImgAlignment,
      ),
    ),
    child: Center(
      child: Stack(
        children: [
          Text(
            categoryName,
            style: TextStyle(
              fontSize: 30,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 6
                ..color = Colors.black,
            ),
          ),
          Text(
            categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SelectCategoryPageState extends State<SelectCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: fictionPage(),
                        type: PageTransitionType.leftToRightWithFade,
                      ),
                    );
                  },
                  child: makeCategoryContainer('assets/images/fictional.jpg',
                      'Ficitional', Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: Non_Fiction_Page(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer('assets/images/anneFrank.jpg',
                      'Non-Fictional', Alignment.bottomCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: HistoricalPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer(
                      'assets/images/wingedHussars.jpg',
                      'Historical',
                      Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: PhilosophyPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer(
                      'assets/images/plato_philosopher.jpg',
                      'Philosophy',
                      Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: SciFiPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer('assets/images/sci_fi.jpg',
                      'Sci-Fi', Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: ComicPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer(
                      'assets/images/comics.jpg', 'Comic', Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: BiographyPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer('assets/images/sittingBull.jpg',
                      'Biography', Alignment.topCenter),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        child: DesignPage(),
                        type: PageTransitionType.fade,
                      ),
                    );
                  },
                  child: makeCategoryContainer(
                      'assets/images/design.jpg', 'Design', Alignment.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}