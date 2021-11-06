//! THE CLASS TO PASS ALL OF THE BOOKS (CLICKED) INFO TO ANOTHER SCREEN
class ScreenArguments {
  late final String bookTitle;
  late final String bookAuthor;
  late final String bookCover;
  late final String bookCategory;
  late final String bookDescription;
  late final String bookOwner;
  late final String bookLanguage;
  late final String bookPublishedYear;
  late final String bookPages;
  late final String bookStartDate;
  late final String bookEndDate;
  late final bool isFavourite;
  late final String bookId;

  ScreenArguments(
    this.bookTitle,
    this.bookAuthor,
    this.bookCover,
    this.bookCategory,
    this.bookDescription,
    this.bookOwner,
    this.bookLanguage,
    this.bookPublishedYear,
    this.bookPages,
    this.bookStartDate,
    this.bookEndDate,
    this.isFavourite,
    this.bookId,
  );
}

//! THE CLASS TO PASS ALL OF THE  LOGGED IN USER (CLICKED) INFO TO ANOTHER SCREEN
class UserArguments {
  late final String age;
  late final String email;
  late final String userPFP;
  late final String totalBooks;
  late final String userUserName;
  late final String userAbout;
  late final String userTotalFavourites;
  late final String userLocation;
  late final int userCreatedDate;
  late final int userCreatedMonth;
  late final int userCreatedYear;
  late final bool isShowLocation;
  late final bool isShowAge;
  late final bool isShowBook;
  late final bool isShowFavourite;

  UserArguments(
    this.age,
    this.email,
    this.userPFP,
    this.totalBooks,
    this.userUserName,
    this.userAbout,
    this.userTotalFavourites,
    this.userLocation,
    this.userCreatedDate,
    this.userCreatedMonth,
    this.userCreatedYear,
    this.isShowLocation,
    this.isShowAge,
    this.isShowBook,
    this.isShowFavourite,
  );
}
