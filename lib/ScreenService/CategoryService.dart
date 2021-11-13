import 'package:flutter/material.dart';
import 'package:library_app/Services/Arguments.dart';
import 'package:library_app/Services/BookService.dart';
import 'package:library_app/Services/UIServices.dart';
import 'package:page_transition/page_transition.dart';

class CategoryService {
  //! MAKE CONTAINER FOR THE (SELECT CATEGORY PAGE)
  static Container makeCategoryContainer(
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

  //! GO NEW SCREEN AFTER CLICKING ON EACH CONTAINER (SELECT CATEGORY PAGE)
  static goNewScreen(BuildContext context, var pageName) {
    return Navigator.push(
      context,
      PageTransition(
        child: pageName,
        type: PageTransitionType.fade,
      ),
    );
  }

  //! CATEGORY PAGE SERVICE
  static Column makeCategoryPageItem(
      String categoryName, imagePath, var allResult, loggedInUser) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
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
                      ..strokeWidth = 10
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
        ),
        UIServices.customDivider(Colors.black),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allResult.length,
          itemBuilder: (context, index) {
            var data = BookService.fromSnapshot(allResult, index);
            return (data.bookOwner == loggedInUser.email &&
                    data.bookCategory == categoryName)
                ? GestureDetector(
                    key: ValueKey(loggedInUser.email),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        'bookInfo',
                        arguments: ScreenArguments(
                          data.bookTitle,
                          data.bookAuthor,
                          data.bookCover,
                          data.bookCategory,
                          data.bookDescription,
                          data.bookOwner,
                          data.bookLanguage,
                          data.bookPublished,
                          data.bookPages,
                          data.bookStartDate.toDate(),
                          data.bookEndDate.toDate(),
                          data.bookIsFavourite,
                          data.bookId,
                        ),
                      );
                    },
                    child: UIServices.buildCardTile(
                        data.bookCover,
                        data.bookCategory,
                        data.bookTitle,
                        data.bookAuthor,
                        true),
                  )
                : SizedBox(
                    height: 0,
                  );
          },
        ),
      ],
    );
  }

  //! MAKE THE WHOLE CATEGORY PAGE BODY
  static Container makeCategoryBody(Color c1, c2, c3, c4, String categoryName,
      imagePath, var allResult, loggedInUser) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [c1, c2, c3, c4],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: CategoryService.makeCategoryPageItem(
              categoryName, imagePath, allResult, loggedInUser),
        ),
      ),
    );
  }
}
