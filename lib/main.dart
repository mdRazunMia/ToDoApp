import 'package:flutter/material.dart';
import './databaseHelper.dart';
import './models/todo.dart';
import './screens/todo_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My todo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyTodoList(),
    );
  }
}

class MyTodoList extends StatefulWidget {
  MyTodoList({Key key}) : super(key: key);

  @override
  _MyTodoListState createState() => _MyTodoListState();
}

class _MyTodoListState extends State<MyTodoList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Todo> todoList;
  int count = 0;

  String get todo => null;
  String get title => null;
  // String get title => null;

  @override
  Widget build(BuildContext context) {
    if (todoList == null) {
      todoList = List<Todo>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('My todo App'),
      ),
      body: getTodoListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Add Todo',
        onPressed: () {
          navigateToDetail(Todo(' ', ' '), 'Add Todo');
        },
      ),
    );
  }

  ListView getTodoListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(
                getFirstLetter(this.todoList[position].title),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              this.todoList[position].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(this.todoList[position].date),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onTap: () {
                    _delete(context, todoList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              navigateToDetail(this.todoList[position], 'Edit Todo');
            },
          ),
        );
      },
    );
  }

  void navigateToDetail(Todo todo, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoDetail(this.title, todo);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Todo>> todoListFuture = databaseHelper.getTodoList();
      todoListFuture.then((todoList) {
        setState(() {
          this.todoList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }

  void _delete(BuildContext context, Todo todo) async {
    int result = await databaseHelper.deleteTodo(todo.id);
    if (result != 0) {
      _showSnakeBar(context, 'Todo Deleted Successfully');
      updateListView();
    }
  }

  void _showSnakeBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }
}
