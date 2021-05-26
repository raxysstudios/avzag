import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url))
    await launch(url);
  else
    throw 'Could not launch $url';
}

class NavDraver extends StatefulWidget {
  @override
  _NavDraverState createState() => _NavDraverState();
}

class _NavDraverState extends State<NavDraver> {
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
          ListTile(
            leading: Icon(
              Icons.map_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Map", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.music_note_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Phonology", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.switch_left_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Converter", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.chat_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Phrasebook", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.book_outlined,
              color: Colors.black,
              size: 30,
            ),
            title: Text("Dictionary", style: TextStyle(fontSize: 18)),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.construction_outlined),
            title: Text("Editor tools"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.forum_outlined),
            title: Text("Telegram channel"),
            trailing: Icon(Icons.open_in_new_outlined),
            onTap: () =>
                launchURL("https://github.com/alkaitagi/avzag_flutter"),
          ),
          ListTile(
            leading: Icon(Icons.code_outlined),
            title: Text("GitHub repository"),
            trailing: Icon(Icons.open_in_new_outlined),
            onTap: () => launchURL("https://t.me/avzag"),
          ),
        ],
      ),
    );
  }
}
