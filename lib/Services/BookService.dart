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
      bookStartDate,
      bookEndDate,
      bookId;
  late bool bookIsFavourite;

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
    bookIsFavourite = snapshot[index]['isFavourite'];
    bookId = snapshot[index]['bookId'];
  }
}
