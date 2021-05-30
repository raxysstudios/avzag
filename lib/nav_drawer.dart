import 'package:avzag/dictionary/dictionary_editor.dart';
import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class _NavItem {
  _NavItem(
    this.icon,
    this.title, {
    this.builder,
    this.link,
    this.selected = false,
  });
  final IconData icon;
  final String title;
  final Widget Function()? builder;
  final String? link;
  final bool selected;

  Widget build(
    BuildContext context, {
    bool small = false,
    bool selected = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 24,
        color: selected
            ? Colors.blue
            : link != null || builder == null
                ? Colors.black45
                : Colors.black,
      ),
      selected: selected,
      title: Text(
        title,
        style: TextStyle(
          color: selected
              ? Colors.blue
              : link == null && builder == null
                  ? Colors.black45
                  : Colors.black,
          fontSize: small ? 14 : 18,
        ),
      ),
      trailing: link == null
          ? builder == null
              ? Icon(Icons.construction_outlined)
              : null
          : Icon(Icons.open_in_new_outlined),
      onTap: link == null
          ? builder == null
              ? null
              : () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => builder!()),
                  );
                }
          : () => launch(link!),
    );
  }
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
    _NavItem(
      Icons.library_add_outlined,
      'Editor tools',
      builder: () => DictionaryEditor(),
    ),
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
    _NavItem(
      Icons.email_outlined,
      'Developer contact',
      link: 'mailto:alkaitagi@outlook.com?subject=Avzag',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            child: Text(
              "Ævzag",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(height: 0),
          for (final m in modules)
            m.build(
              context,
              selected: m.title == title,
            ),
          Divider(height: 0),
          for (final m in submodules)
            m.build(
              context,
              small: true,
            ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16,
            ),
            child: Text(
              "Developed in Dagestan, North Caucasus.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
