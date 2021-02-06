import 'package:flutter/material.dart';
import 'package:memo/helper/database_helper.dart';
import 'package:memo/models/note.dart';
import 'package:memo/utils/constants.dart';

class NoteProvider with ChangeNotifier {
  List _items = [];
  List get items {
    return [..._items];
  }

  Note getNote(int id) {
    return _items.firstWhere((note) => note.id == id, orElse: () => null);
  }

  Future getNotes() async {
    final noteList = await DatabaseHelper.getNotesFromDB();
    _items = noteList
        .map((item) => Note(
              item['id'],
              item['title'],
              item['content'],
              item['imagePath'],
            ))
        .toList();
    notifyListeners();
  }
  Future addOrUpdateNote(int id, String title, String content,
      String imagePath, EditMode editMode) async {
    final note = Note(id, title, content, imagePath);

    if (EditMode.ADD == editMode) {
      _items.insert(0, note);
    } else {
      _items[_items.indexWhere((note) => note.id == id)] = note;
    }

    notifyListeners();

    DatabaseHelper.insert(
      {
        'id': note.id,
        'title': note.title,
        'content': note.content,
        'imagePath': note.imagePath,
      },
    );
  }
  // Future addOrUpdate(
  //   int id,
  //   String title,
  //   String content,
  //   String imagePath,
  //   EditMode editMode,
  // ) {
  //   final note = Note(id, title, content, imagePath);
  //   if (EditMode.ADD == editMode) {
  //     _items.insert(0, note);
  //   } else {
  //     _items[_items.indexWhere((note) => note.id == id)] = note;
  //   }
  //   notifyListeners();
  //   DatabaseHelper.insert({
  //     'id': note.id,
  //     'title': note.title,
  //     'content': note.content,
  //     'imagePath': note.imagePath
  //   });
  // }

  Future deleteNote(int id) {
    _items.removeWhere((note) => note.id == id);
    notifyListeners();
    return DatabaseHelper.delete(id);
  }
}
