import 'package:avzag/sound_manager.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/phonology/phoneme/phoneme_button.dart';
import 'package:avzag/phonology/phoneme/phoneme_card.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class PhonologyPage extends StatefulWidget {
  @override
  _PhonologyPageState createState() => _PhonologyPageState();
}

class _PhonologyPageState extends State<PhonologyPage> {
  final pageController = PageController();
  late String phoneme;

  @override
  void initState() {
    super.initState();
    phoneme = PhonologyStore.phonemes.keys.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionaries'),
      ),
      drawer: NavDraver(title: 'phonology'),
      body: PageView(
        controller: pageController,
        children: [
          ListView(
            children: [
              for (final p in PhonologyStore.phonemes.entries)
                PhonemeButton(
                  p.key,
                  onTap: () {},
                ),
            ],
          ),
          Column(
            children: [
              for (final p in PhonologyStore.phonemes[phoneme]!.entries)
                PhonemeCard(
                  p.value,
                  language: p.key,
                  playing: SoundManager.url,
                  onPlay: (url) => SoundManager.playUrl(
                    url,
                    onStart: () => setState(() {}),
                  ).then(
                    (_) => setState(() {}),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
