import 'package:flutter/material.dart';
import 'package:flutter_application_1/BookInfoPage.dart';
import 'package:flutter_application_1/Contact.dart';
import 'package:flutter_application_1/database_helper.dart';

const darkBlueColor = Color(0xff486579);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SqLite CRUD',
      theme: ThemeData(
        primaryColor: darkBlueColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'SQLite CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Book> _books = [];
  DatabaseHelper _dbHelper;
  final _formKey = GlobalKey<FormState>();
  final _ctrlName = TextEditingController();
  final _ctrlPrice = TextEditingController();
  final _ctrlAuthor = TextEditingController();

  Book _book = Book();

  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
    });
    _refreshBookList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
            child: Text(
          widget.title,
          style: TextStyle(color: darkBlueColor),
        )),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_books.length > 0 ? _list() : Container()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookInfo(),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  _refreshBookList() async {
    List<Book> x = await _dbHelper.fetchBooks();
    setState(() {
      _books = x;
      print(x[0].author);
      print(_books.length);
    });
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlPrice.clear();
      _ctrlAuthor.clear();
      _book.id = null;
    });
  }

  _list() => Expanded(
        child: Card(
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView.builder(
              itemCount: _books.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.book_outlined,
                        color: darkBlueColor,
                        size: 40.0,
                      ),
                      title: Text(
                        _books[index].name.toUpperCase(),
                        style: TextStyle(
                            color: darkBlueColor, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_books[index].author),
                          Text(_books[index].price),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_sweep,
                          color: darkBlueColor,
                        ),
                        onPressed: () async {
                          await _dbHelper.deleteBook(_books[index].id);
                          _resetForm();
                          _refreshBookList();
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _book = _books[index];
                          _ctrlName.text = _books[index].name;
                          _ctrlPrice.text = _books[index].price;
                          _ctrlAuthor.text = _books[index].author;
                        });
                      },
                    ),
                    Divider(
                      height: 5.0,
                    ),
                  ],
                );
              }),
        ),
      );
}
