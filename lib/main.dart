import 'package:flutter/material.dart';
import 'package:memo/helper/note_provider.dart';
import 'package:memo/screens/note_edit_screen.dart';
import 'package:memo/screens/note_list_screen.dart';
import 'package:memo/screens/note_view_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: NoteProvider(),
      child: MaterialApp(
        title: "Memo Notes",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => NoteListScreen(),
          NoteEditScreen.route: (context) => NoteEditScreen(),
          NoteViewScreen.route: (context) => NoteViewScreen(),
        },
      ),
    );
  }
}
