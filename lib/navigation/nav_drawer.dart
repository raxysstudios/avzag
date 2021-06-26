import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/navigation/editor_toggle.dart';
import 'package:avzag/phonology/phonology_page.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'expandable_title.dart';

Future<void> navigate(
  BuildContext context,
  String? title,
) async {
  final prefs = await SharedPreferences.getInstance();
  if (title == null) {
    title = prefs.getString('module');
    if (title == null || title == 'home') title = 'dictionary';
  }

  late Widget Function(BuildContext) builder;
  if (title == 'home') {
    builder = (_) => HomePage();
    title = null;
  } else if (title == 'phonology')
    builder = (_) => PhonologyPage();
  else if (title == 'dictionary')
    builder = (_) => DictionaryPage();
  else
    builder = (_) => Text("No Route");

  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: builder),
  );
  if (title != null) await prefs.setString('module', title);
}

class _NavModule {
  final IconData icon;
  final String text;
  final bool enabled;
  _NavModule(this.icon, this.text, this.enabled);

  Widget build(BuildContext context, bool selected) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        capitalize(text),
        style: TextStyle(fontSize: 18),
      ),
      trailing: enabled ? null : Icon(Icons.construction_outlined),
      selected: selected,
      onTap: enabled ? () => navigate(context, text) : null,
      enabled: enabled,
    );
  }
}

class _NavLink {
  final IconData icon;
  final String text;
  final String url;
  _NavLink(this.icon, this.text, this.url);

  Widget build() {
    return ListTile(
      leading: Icon(icon),
      title: Text(capitalize(text)),
      trailing: Icon(Icons.open_in_new_outlined),
      onTap: () => launch(url),
    );
  }
}

class NavDraver extends StatelessWidget {
  NavDraver({this.title});
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ExpandableTitle(
            [
              EditorSwitch(),
              ...[
                _NavLink(
                  Icons.send_outlined,
                  'developer contact',
                  'https://t.me/alkaitagi',
                ),
                _NavLink(
                  Icons.forum_outlined,
                  'telegram channel',
                  'https://t.me/avzag',
                ),
                _NavLink(
                  Icons.code_outlined,
                  'GitHub repository',
                  'https://github.com/alkaitagi/avzag_flutter',
                ),
              ].map((e) => e.build()),
            ],
          ),
          Divider(height: 0),
          ...[
            _NavModule(Icons.map_outlined, 'home', true),
            _NavModule(Icons.music_note_outlined, 'phonology', false),
            _NavModule(Icons.switch_left_outlined, 'converter', false),
            _NavModule(Icons.book_outlined, 'dictionary', true),
            _NavModule(Icons.local_library_outlined, 'bootcamp', false),
            _NavModule(Icons.tour_outlined, 'quests', false),
          ].map((e) => e.build(context, e.text == title))
        ],
      ),
    );
  }
}
