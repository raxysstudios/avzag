import 'package:avzag/home/models.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/nav_drawer.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> selected = Set();
  List<Language> languages = [];
  Future? loader;

  @override
  void initState() {
    super.initState();
    loader = FirebaseFirestore.instance
        .collection('languages')
        .orderBy('family')
        .orderBy('name')
        .withConverter(
          fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
          toFirestore: (Language language, _) => language.toJson(),
        )
        .get()
        .then((d) async {
      languages = d.docs.map((l) => l.data()).toList();
      for (final l in languages) await donwloadFlag(l);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loader,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          drawer: NavDraver(title: "Home"),
          body: Builder(
            builder: (context) {
              if (snapshot.hasError) return Text("Something went wrong.");
              if (snapshot.connectionState != ConnectionState.done)
                return Text("Loading, please wait...");
              return Column(
                children: [
                  Container(
                    height: 48,
                    child: selected.isEmpty
                        ? Center(
                            child: Text(
                              "Selected languages appear here.",
                              style: TextStyle(
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              for (final n in selected)
                                Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: InputChip(
                                    label: Text(
                                      capitalize(n),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    onPressed: () => setState(
                                      () => selected.remove(n),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                  Divider(height: 2),
                  Expanded(
                    child: ListView.separated(
                      itemCount: languages.length,
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
                    ),
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
