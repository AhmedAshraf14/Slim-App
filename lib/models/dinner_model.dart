class Dinner {
  int? id;
  final String title;
  DateTime creationDate;
  bool isChecked;

  // create the constructor
  Dinner({
    this.id,
    required this.title,
    required this.creationDate,
    required this.isChecked,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'creationDate': creationDate
          .toString(), // sqflite database doesn't support the datetime type so we will save it as Text.
      'isChecked': isChecked
          ? 1
          : 0, // it doesn't support the boolean either, so we save that as integer.
    };
  }
  @override
  String toString() {
    return 'Dinner(id : $id, title : $title, creationDate : $creationDate, isChecked : $isChecked)';
  }
}
