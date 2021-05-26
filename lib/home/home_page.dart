import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/nav_drawer.dart';
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
            title: Text(
              "Home",
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
          drawer: NavDraver(title: "Home"),
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
