import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/navigation/editor_switch.dart';
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
  } else if (title == 'dictionary')
    builder = (_) => DictionaryPage();
  else
    builder = (_) => Text("No Route");

  if (title != null) await prefs.setString('module', title);
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: builder),
  );
}

class _NavModule {
  final IconData icon;
  final String text;
  _NavModule(this.icon, this.text);

  Widget build(BuildContext context, {bool? selected}) {
    final enabled = selected != null;
    return ListTile(
      leading: Icon(icon),
      title: Text(
        capitalize(text),
        style: TextStyle(fontSize: 18),
      ),
      trailing: enabled ? null : Icon(Icons.construction_outlined),
      selected: selected ?? false,
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
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            Material(
              color: Colors.transparent,
              child: ExpandableTitle(
                [
                  Card(
                    child: Column(
                      children: [
                        EditorSwitch(),
                        ...[
                          _NavLink(
                            Icons.send_outlined,
                            'developer contact',
                            'https://t.me/alkaitagi',
                          ),
                          _NavLink(
                            Icons.code_outlined,
                            'GitHub repository',
                            'https://github.com/alkaitagi/avzag_flutter',
                          ),
                        ].map((e) => e.build()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                children: [
                  ...[
                    _NavModule(Icons.map_outlined, 'home'),
                    _NavModule(Icons.book_outlined, 'dictionary'),
                  ].map(
                    (t) => t.build(
                      context,
                      selected: t.text == title,
                    ),
                  ),
                  Divider(height: 0),
                  ...[
                    _NavModule(Icons.music_note_outlined, 'phonology'),
                    _NavModule(Icons.switch_left_outlined, 'converter'),
                    _NavModule(Icons.sms_outlined, 'phrasebook'),
                    _NavModule(Icons.local_library_outlined, 'bootcamp'),
                  ].map((t) => t.build(context)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
