import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/phonology/phoneme/phoneme_button.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class PhonologyPage extends StatefulWidget {
  @override
  _PhonologyPageState createState() => _PhonologyPageState();
}

class _PhonologyPageState extends State<PhonologyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionaries'),
      ),
      drawer: NavDraver(title: 'phonology'),
      body: ListView(
        children: [
          for (final p in PhonologyStore.phonemes.entries)
            PhonemeButton(
              p.key,
              onTap: () {},
            ),
        ],
      ),
    );
  }
}
