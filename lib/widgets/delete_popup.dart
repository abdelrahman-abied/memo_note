import 'package:flutter/material.dart';
import 'package:memo/helper/note_provider.dart';
import 'package:memo/models/note.dart';
import 'package:provider/provider.dart';

class DeletePopup extends StatelessWidget {
  final Note selectedNote;

  const DeletePopup({Key key, this.selectedNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      title: Text("delete?"),
      content: Text("Do you want to delete the note?"),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<NoteProvider>(context,listen: false).deleteNote(selectedNote.id);
            Navigator.popUntil(context, ModalRoute.withName("/"));
          },
          child: Text("Yes"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("No"),
        ),
      ],
    );
  }
}
