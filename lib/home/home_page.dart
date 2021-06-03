import 'package:avzag/firebase_builder.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'language_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<void> loader;
  final Set<String> selected = new Set();
  final Set<String> oldSelected = new Set();
  bool get selectedDiffer => !setEquals(selected, oldSelected);

  @override
  void initState() {
    super.initState();
    loader = load()
        .then((_) => SharedPreferences.getInstance())
        .then((prefs) => prefs.getStringList('selectedLanguages'))
        .then((values) {
      values = values ?? [];
      selected
        ..clear()
        ..addAll(values);
      oldSelected
        ..clear()
        ..addAll(values);
      print("SELECTED $selected");
    });
  }

  void downloadLanguages() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(
          Duration(seconds: 1),
          () => Navigator.pop(context),
        );
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              height: 128,
              width: 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Downloading, please wait..."),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureLoader(
      future: loader,
      builder: (body) => Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: NavDraver(title: 'Home'),
        floatingActionButton: FloatingActionButton(
          onPressed: downloadLanguages,
          child: Icon(
            selectedDiffer ? Icons.download_outlined : Icons.refresh_outlined,
          ),
          tooltip: selectedDiffer ? "Donwload data" : "Refresh data",
        ),
        body: body,
      ),
      body: () => Column(
        children: [
          Container(
            height: 48,
            child: selected.isEmpty
                ? Center(
                    child: Text(
                      'Selected languages appear here.',
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
      ),
    );
  }
}
