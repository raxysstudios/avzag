import 'package:flutter/material.dart';

class UseEditor extends StatefulWidget {
  @override
  _UseEditorState createState() => _UseEditorState();
}

class _UseEditorState extends State<UseEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usecase editor"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Text("AEAEAEAE"),
    );
  }
}
