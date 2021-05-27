import 'package:avzag/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class HomePage extends StatefulWidget {
  final loader = FirebaseFirestore.instance
      .collectionGroup('dictionary')
      .withConverter(
        fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
        toFirestore: (Entry language, _) => language.toJson(),
      )
      .get();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> selected = Set();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Entry>>(
      future: widget.loader,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Entry>> snapshot,
      ) {
        final dictionaries = snapshot.data?.docs.map((l) => l.data()).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Dictionaries",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: NavDraver(title: "Home"),
          body: Builder(
            builder: (context) {
              if (snapshot.hasError || dictionaries == null)
                return Text("Something went wrong.");
              if (snapshot.connectionState != ConnectionState.done)
                return Text("Loading, please wait...");
              return Column(
                children: [
                  for (final e in dictionaries) Text(e.forms[0].plain),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
