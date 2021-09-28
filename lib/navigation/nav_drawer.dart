import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/home_page.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'auth_page.dart';
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
    builder = (_) => const HomePage();
    title = null;
  } else if (title == 'dictionary') {
    builder = (_) => const DictionaryPage();
  } else {
    builder = (_) => const Text("No Route");
  }

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
        style: const TextStyle(fontSize: 18),
      ),
      trailing: enabled ? null : const Icon(Icons.construction_outlined),
      selected: selected ?? false,
      onTap: enabled ? () => navigate(context, text) : null,
      enabled: enabled,
    );
  }
}

class NavDraver extends StatelessWidget {
  final String? title;

  const NavDraver({
    Key? key,
    this.title,
  }) : super(key: key);

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
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.landscape_outlined),
                        title: const Text('Made with honor in\nNorth Caucasus'),
                        trailing: const Icon(Icons.send_outlined),
                        onTap: () => launch('https://t.me/raxysstudios'),
                      ),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          var info = 'Loading...';
                          final package = snapshot.data;
                          if (package != null) {
                            info = [
                              'v' + package.version,
                              'b' + package.buildNumber
                            ].join(' • ');
                          }
                          return ListTile(
                            leading: const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Icon(Icons.code_outlined),
                            ),
                            title: const Text('GitHub Repository'),
                            subtitle: Text(info),
                            trailing: const Icon(Icons.open_in_new_outlined),
                            onTap: () => launch(
                              'https://github.com/raxysstudios/avzag',
                            ),
                          );
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Editor Mode'),
                        subtitle: Text(
                          GlobalStore.editing == null
                              ? 'Off'
                              : capitalize(GlobalStore.editing!),
                        ),
                        value: GlobalStore.editing != null,
                        secondary: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Icon(Icons.edit_outlined),
                        ),
                        onChanged: (e) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Card(
              child: Column(
                children: [
                  ...[
                    _NavModule(Icons.home_outlined, 'home'),
                    _NavModule(Icons.book_outlined, 'dictionary'),
                  ].map(
                    (t) => t.build(
                      context,
                      selected: t.text == title,
                    ),
                  ),
                  const Divider(height: 0),
                  ...[
                    _NavModule(Icons.music_note_outlined, 'phonology'),
                    _NavModule(Icons.switch_left_outlined, 'converter'),
                    _NavModule(Icons.forum_outlined, 'phrasebook'),
                    _NavModule(Icons.local_library_outlined, 'bootcamp'),
                    _NavModule(Icons.insights_outlined, 'quests'),
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
