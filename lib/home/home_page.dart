import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  final loader = FirebaseFirestore.instance
      .collection('languages')
      .withConverter(
        fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
        toFirestore: (Language language, _) => language.toJson(),
      )
      .get();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> selected = Set();

  @override
  Widget build(BuildContext context) {
    // FirebaseFirestore.instance.settings = Settings(persistenceEnabled: false);
    return FutureBuilder<QuerySnapshot<Language>>(
      future: widget.loader,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot<Language>> snapshot,
      ) {
        final languages = snapshot.data?.docs.map((l) => l.data()).toList();
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
                  ? ListView.separated(
                      itemBuilder: (context, index) {
                        final lang = languages[index];
                        final contains = this.selected.contains(lang.name);
                        return LanguageCard(
                          lang,
                          selected: contains,
                          onTap: () => setState(
                            () => contains
                                ? selected.remove(lang.name)
                                : selected.add(lang.name),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: 2,
                        color: Colors.transparent,
                      ),
                      itemCount: languages.length,
                    )
                  : Text("loading"),
        );
      },
    );
  }
}
