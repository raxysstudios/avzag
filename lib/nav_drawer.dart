import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDraver extends StatefulWidget {
  @override
  _NavDraverState createState() => _NavDraverState();
}

class _NavItem {
  _NavItem(this.icon, this.title, {this.link});
  final IconData icon;
  final String title;
  final String? link;
}

class _NavDraverState extends State<NavDraver> {
  final modules = [
    _NavItem(Icons.map_outlined, 'Home'),
    _NavItem(Icons.music_note_outlined, 'Phonology'),
    _NavItem(Icons.switch_left_outlined, 'Converter'),
    _NavItem(Icons.chat_outlined, 'Phrasebook'),
    _NavItem(Icons.book_outlined, 'Dictionary'),
  ];
  final submodules = [
    _NavItem(Icons.construction_outlined, 'Editor tools'),
    _NavItem(
      Icons.forum_outlined,
      'Editor tools',
      link: 'https://t.me/avzag',
    ),
    _NavItem(
      Icons.construction_outlined,
      'Editor tools',
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
          Divider(),
          for (final m in modules)
            ListTile(
              leading: Icon(
                m.icon,
                color: Colors.black,
                size: 30,
              ),
              title: Text(m.title, style: TextStyle(fontSize: 18)),
              onTap: () {},
            ),
          Divider(),
          for (final m in submodules)
            ListTile(
              leading: Icon(m.icon),
              title: Text(m.title),
              trailing:
                  m.link == null ? null : Icon(Icons.open_in_new_outlined),
              onTap: m.link == null ? null : () => launch(m.link!),
            ),
        ],
      ),
    );
  }
}
