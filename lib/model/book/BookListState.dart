class BookListState {
  List<StudyBook> studyBooks;

  BookListState ({
    required this.studyBooks,
  });
}

class StudyBook {
  int id;
  String name;
  int questionCount;
  String FileColor;
  DateTime CreatedAt;

  StudyBook ({
    required this.id,
    required this.name,
    required this.questionCount,
    required this.FileColor,
    required this.CreatedAt
  });
}