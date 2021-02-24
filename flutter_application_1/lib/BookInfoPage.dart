import 'package:flutter/material.dart';
import 'package:flutter_application_1/Contact.dart';
import 'package:flutter_application_1/database_helper.dart';
import 'package:flutter_application_1/main.dart';

class BookInfo extends StatefulWidget {
  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
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
            'BOOK INFO',
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_form(), _list()],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _ctrlName,
                decoration: InputDecoration(labelText: 'Book Name'),
                onSaved: (val) => setState(() => _book.name = val),
                validator: (val) =>
                    (val.length == 0 ? 'This Field is required' : null),
              ),
              TextFormField(
                controller: _ctrlPrice,
                decoration: InputDecoration(labelText: 'Price'),
                onSaved: (val) => setState(() => _book.price = val),
                validator: (val) =>
                    (val.length == 0 ? 'This Field is required' : null),
              ),
              TextFormField(
                controller: _ctrlAuthor,
                decoration: InputDecoration(labelText: 'Author'),
                onSaved: (val) => setState(() => _book.author = val),
                validator: (val) =>
                    (val.length == 0 ? 'This Field is required' : null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                  onPressed: () async {
                    // var sendData = _refreshBookList();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                    _onSubmit();
                  },
                  child: Text('ADD'),
                  color: darkBlueColor,
                  textColor: Colors.white,
                ),
              )
            ],
          ),
        ),
      );

  _refreshBookList() async {
    List<Book> x = await _dbHelper.fetchBooks();
    setState(() {
      _books = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (_book.id == null)
        await _dbHelper.insertBook(_book);
      else
        await _dbHelper.updateBook(_book);
      _refreshBookList();
      _resetForm();
    }
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
              itemCount: _books.length > 0 ? _list() : Container(),
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
