import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    return FutureBuilder<QuerySnapshot<Language>>(
      future: FirebaseFirestore.instance
          .collection('languages')
          .withConverter(
            fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
            toFirestore: (Language language, _) => language.toJson(),
          )
          .get(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Language>> snapshot,
      ) {
        final languages = snapshot.data?.docs.map((l) => l.data());
        languages?.forEach(donwloadFlag);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            title: Text(
              "Avzag",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                DrawerHeader(
                  child: Text(
                    "Map",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.map),
                  title: Text("Map"),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(Icons.music_note),
                  title: Text("Phonology"),
                  onTap: () {},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.forum),
                  title: Text("Channel"),
                  onTap: () {},
                ),
              ],
            ),
          ),
          body: snapshot.hasError || languages == null
              ? Text("Something went wrong")
              : snapshot.connectionState == ConnectionState.done
                  ? Column(
                      children: [
                        for (final l in languages)
                          LanguageCard(
                            l,
                            onTap: () {},
                          ),
                      ],
                    )
                  : Text("loading"),
        );
      },
    );
  }
}
