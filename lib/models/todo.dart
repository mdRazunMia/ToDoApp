// import 'package:flutter/cupertino.dart';

class Todo {
  int _id;
  String _title;
  String _date;

  Todo(this._title, this._date);

  Todo.withId(this._id, this._title, this._date);

  int get id => _id;

  String get title => _title;

  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['date'] = _date;

    return map;
  }

  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._date = map['date'];
  }
}
