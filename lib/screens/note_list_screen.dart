import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:memo/helper/note_provider.dart';
import 'package:memo/utils/constants.dart';
import 'package:memo/widgets/list_item.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'note_edit_screen.dart';

class NoteListScreen extends StatefulWidget {
  NoteListScreen({Key key}) : super(key: key);

  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<NoteProvider>(context, listen: false).getNotes(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              body: Consumer<NoteProvider>(
                child: noNotesUI(context),
                builder: (context, noteProvider, child) {
                  return noteProvider.items.length <= 0
                      ? child
                      : ListView.builder(
                        physics: BouncingScrollPhysics(),
                          itemCount: noteProvider.items.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return header();
                            } else {
                              final i = index - 1;
                              final item = noteProvider.items[i];
                              return ListItem(
                                id: item.id,
                                title: item.title,
                                content: item.content,
                                imagePath: item.imagePath,
                                date: item.date,
                              );
                            }
                          });
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  goToNoteEditScreen(context);
                },
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget header() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        decoration: BoxDecoration(
          color: headerColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(75.0),
          ),
        ),
        height: 150.0,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Memo ",
              style: headerRideStyle,
            ),
            Text(
              "Notes",
              style: headerNotesStyle,
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl() async {
    const url = 'https://www.google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'can not launch $url';
    }
  }

  Widget noNotesUI(BuildContext context) {
    return ListView(
      children: [
        header(),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Image.asset(
                'assets/crying_emoji.png',
                fit: BoxFit.fill,
                width: 200,
                height: 200,
              ),
            ),
            RichText(
              text: TextSpan(style: noNotesStyle, children: [
                TextSpan(text: 'There is no note available\n tap on "'),
                TextSpan(
                  text: '+',
                  style: boldPlus,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      goToNoteEditScreen(context);
                    },
                ),
                TextSpan(text: '" to add new note')
              ]),
            ),
          ],
        )
      ],
    );
  }

  void goToNoteEditScreen(BuildContext context) {
    Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
}
