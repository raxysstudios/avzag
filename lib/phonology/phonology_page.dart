import 'package:avzag/home/models.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PhonologyPage extends StatefulWidget {
  @override
  _PhonologyPageState createState() => _PhonologyPageState();
}

class _PhonologyPageState extends State<PhonologyPage> {
  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    return FutureBuilder<QuerySnapshot<Language>>(
      // future: FirebaseFirestore.instance
      //     .collection('languages')
      //     .withConverter(
      //       fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
      //       toFirestore: (Language language, _) => language.toJson(),
      //     )
      //     .get(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Language>> snapshot,
      ) {
        final languages = snapshot.data?.docs.map((l) => l.data());
        languages?.forEach(donwloadFlag);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Phonology",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.filter),
                onPressed: () {},
              ),
            ],
          ),
          drawer: NavDraver(title: "Phonology"),
          body: Text("Phonology"),
        );
      },
    );
  }
}
