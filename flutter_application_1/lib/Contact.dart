class Book {
  static const tblBook = 'book';
  static const colId = 'id';
  static const colName = 'name';
  static const colPrice = 'price';
  static const colAuthor = 'author';
  Book({this.id, this.name, this.price, this.author});

  Book.fromMap(Map<String, dynamic> map) {
    id = map[colId];
    name = map[colName];
    price = map[colPrice];
    author = map[colAuthor];
  }
  int id;
  String name;
  String price;
  String author;

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      colId: id,
      colName: name,
      colPrice: price,
      colAuthor: author
    };
    if (id != null) map[colId] = id;
    return map;
  }
}
