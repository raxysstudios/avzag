import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'store.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Set<String> newSelected = new Set();
  bool get selectedDiffer => !setEquals(selected, newSelected);

  @override
  void initState() {
    super.initState();
    newSelected.addAll(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: NavDraver(title: 'Home'),
      floatingActionButton: FloatingActionButton(
        onPressed: () => loadAll(context),
        child: Icon(
          selectedDiffer ? Icons.download_outlined : Icons.refresh_outlined,
        ),
        tooltip: selectedDiffer ? 'Donwload data' : 'Refresh data',
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
                final contains = selected.contains(lang.name);
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
