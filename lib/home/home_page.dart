import 'package:avzag/home/models.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Set<Language> selected;

  @override
  void initState() {
    super.initState();
    selected = Set.from(loadedLanguages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: NavDraver(title: 'Home'),
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                  'languages',
                  selected.map((l) => l.name).toList(),
                );
                await loadAll(context);
              },
              child: Icon(Icons.download_outlined),
              tooltip: 'Download data',
            ),
      body: Column(
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
                      for (final l in selected)
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: InputChip(
                            label: Text(
                              capitalize(l.name),
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => setState(
                              () => selected.remove(l),
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
                final contains = selected.contains(lang);
                return LanguageCard(
                  lang,
                  selected: contains,
                  onTap: () => setState(
                    () => contains ? selected.remove(lang) : selected.add(lang),
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
