import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  late String bookTitle,
      bookOwner,
      bookCover,
      bookCategory,
      bookAuthor,
      bookDescription,
      bookLanguage,
      bookPublished,
      bookPages,
      bookId;
  late bool bookIsFavourite;
  late Timestamp bookStartDate, bookEndDate;
  late DateTime realBookStartDate, realBookEndDate;

  BookService.fromSnapshot(var snapshot, index) {
    bookTitle = snapshot[index]['title'];
    bookOwner = snapshot[index]['owner'];
    bookCover = snapshot[index]['imageURL'];
    bookCategory = snapshot[index]['category'];
    bookAuthor = snapshot[index]['author'];
    bookDescription = snapshot[index]['description'];
    bookLanguage = snapshot[index]['language'];
    bookPublished = snapshot[index]['publishedYear'];
    bookPages = snapshot[index]['numberOfPages'];
    bookStartDate = snapshot[index]['startDate'];
    bookEndDate = snapshot[index]['endDate'];
    realBookStartDate = bookStartDate.toDate();
    realBookEndDate = bookEndDate.toDate();
    bookIsFavourite = snapshot[index]['isFavourite'];
    bookId = snapshot[index]['bookId'];
  }
}
