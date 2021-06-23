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
    return Column(
      children: [
        for (final p in PhonologyStore.phonemes.entries) PhonemeButton(p.key),
      ],
    );
  }
}
