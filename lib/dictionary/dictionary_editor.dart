import 'package:avzag/dictionary/entry/entry_editor.dart';
import 'package:avzag/home/models.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';
import '../nav_drawer.dart';
import '../utils.dart';
import 'entry/entry.dart';

class DictionaryEditor extends StatefulWidget {
  @override
  _DictionaryEditorState createState() => _DictionaryEditorState();
}

class _DictionaryEditorState extends State<DictionaryEditor> {
  Language language = languages[0];

  void editEntry(Entry? entry) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EntryEditor(
          entry ?? Entry(forms: []),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(milliseconds: 10)),
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Editor",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => editEntry(null),
                icon: Icon(Icons.add_outlined),
              ),
              SizedBox(width: 4),
            ],
          ),
          drawer: NavDraver(title: "Editor"),
          body: Builder(
            builder: (context) {
              return Column(
                children: [
                  DropdownButtonFormField<Language>(
                    value: language,
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        bottom: 11,
                      ),
                    ),
                    items: languages.map((l) {
                      return DropdownMenuItem(
                        value: l,
                        child: Text(capitalize(l.name)),
                      );
                    }).toList(),
                    onChanged: (l) => setState(() {
                      language = l ?? languages[0];
                    }),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
