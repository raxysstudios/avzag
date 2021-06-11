import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/navigation/editor_toggle.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'expandable_title.dart';

void navigate(
  BuildContext context,
  String title,
) {
  late Widget Function(BuildContext) builder;
  if (title == 'home')
    builder = (_) => HomePage();
  else if (title == 'dictionary')
    builder = (_) => DictionaryPage();
  else
    builder = (_) => Text("NO ROUTE FOUND");

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: builder),
  );
  SharedPreferences.getInstance().then(
    (prefs) => prefs.setString('module', title),
  );
}

class NavDraver extends StatelessWidget {
  NavDraver({this.title});
  final String? title;

  Widget buildTitle(String text, {bool disabled = false}) {
    return Text(
      capitalize(text),
      style: TextStyle(fontSize: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ExpandableTitle(
            Column(
              children: [
                Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Greetings from Dagestan, North Caucasus.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Divider(height: 0),
                EditorSwitch(),
                ListTile(
                  leading: Icon(Icons.send_outlined),
                  title: Text('Developer contact'),
                  trailing: Icon(Icons.open_in_new_outlined),
                  onTap: () => launch(
                    'https://t.me/alkaitagi',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.forum_outlined),
                  title: Text('Telegram channel'),
                  trailing: Icon(Icons.open_in_new_outlined),
                  onTap: () => launch(
                    'https://t.me/avzag',
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.code_outlined),
                  title: Text('GitHub repository'),
                  trailing: Icon(Icons.open_in_new_outlined),
                  onTap: () => launch(
                    'https://github.com/alkaitagi/avzag_flutter',
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          ListTile(
            leading: Icon(Icons.map_outlined),
            title: buildTitle('home'),
            selected: title == 'home',
            onTap: () => navigate(context, 'home'),
          ),
          ListTile(
            leading: Icon(Icons.music_note_outlined),
            title: buildTitle('phonology'),
            trailing: Icon(Icons.construction_outlined),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Icons.switch_left_outlined),
            title: buildTitle('converter'),
            trailing: Icon(Icons.construction_outlined),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Icons.chat_outlined),
            title: buildTitle('phrasebook'),
            trailing: Icon(Icons.construction_outlined),
            enabled: false,
          ),
          ListTile(
            leading: Icon(Icons.book_outlined),
            title: buildTitle('dictionary'),
            selected: title == 'dictionary',
            onTap: () => navigate(context, 'dictionary'),
          ),
          ListTile(
            leading: Icon(Icons.local_library_outlined),
            title: buildTitle('bootcamp'),
            trailing: Icon(Icons.construction_outlined),
            enabled: false,
          ),
        ],
      ),
    );
  }
}
