import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'Contact.dart';

class DatabaseHelper {
  static const _databaseName = 'BookData.db';
  static const _databaseversion = 1;

  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseversion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE ${Book.tblBook}(
      ${Book.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${Book.colName} TEXT NOT NULL,
      ${Book.colPrice} TEXT NOT NULL,
      ${Book.colAuthor} TEXT NOT NULL)''');
  }

  Future<int> insertBook(Book book) async {
    Database db = await database;
    return await db.insert(Book.tblBook, book.toMap());
  }

  Future<int> updateBook(Book book) async {
    Database db = await database;
    return await db.update(Book.tblBook, book.toMap(),
        where: '${Book.colId}=?', whereArgs: [book.id]);
  }

  Future<int> deleteBook(int id) async {
    Database db = await database;
    return await db
        .delete(Book.tblBook, where: '${Book.colId}=?', whereArgs: [id]);
  }

  Future<List<Book>> fetchBooks() async {
    Database db = await database;
    List<Map> books = await db.query(Book.tblBook);
    return books.length == 0 ? [] : books.map((e) => Book.fromMap(e)).toList();
  }
}
