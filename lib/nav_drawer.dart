import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/phonology/phonology_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _NavItem {
  _NavItem(this.icon, this.title, {this.builder, this.link});
  final IconData icon;
  final String title;
  final Widget Function()? builder;
  final String? link;
}

class NavDraver extends StatelessWidget {
  NavDraver({this.title});
  final String? title;

  final modules = [
    _NavItem(
      Icons.map_outlined,
      'Home',
      builder: () => HomePage(),
    ),
    _NavItem(
      Icons.music_note_outlined,
      'Phonology',
      // builder: () => PhonologyPage(),
    ),
    _NavItem(Icons.switch_left_outlined, 'Converter'),
    _NavItem(Icons.chat_outlined, 'Phrasebook'),
    _NavItem(
      Icons.book_outlined,
      'Dictionary',
      builder: () => DictionaryPage(),
    ),
    _NavItem(
      Icons.local_library_outlined,
      'Bootcamp',
    ),
  ];
  final submodules = [
    _NavItem(Icons.construction_outlined, 'Editor tools'),
    _NavItem(
      Icons.forum_outlined,
      'Telegram channel',
      link: 'https://t.me/avzag',
    ),
    _NavItem(
      Icons.code_outlined,
      'GitHub repository',
      link: 'https://github.com/alkaitagi/avzag_flutter',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Ævzag",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(height: 0),
          for (final m in modules)
            ListTile(
              leading: Icon(
                m.icon,
                color: title == m.title ? Colors.blue : Colors.black,
                size: 30,
              ),
              title: Text(m.title, style: TextStyle(fontSize: 18)),
              trailing: m.builder == null ? Text("Coming Soon") : null,
              selected: title == m.title,
              onTap: m.builder == null
                  ? null
                  : () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => m.builder!()),
                      );
                    },
            ),
          Divider(height: 0),
          for (final m in submodules)
            ListTile(
              leading: Icon(m.icon),
              title: Text(m.title),
              trailing: m.link == null
                  ? m.builder == null
                      ? Text("Coming Soon")
                      : null
                  : Icon(Icons.open_in_new_outlined),
              onTap: m.link == null ? null : () => launch(m.link!),
            ),
        ],
      ),
    );
  }
}
