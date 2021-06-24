import 'package:avzag/phonology/phoneme/phoneme.dart';
import 'package:avzag/sound_manager.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/phonology/phoneme/phoneme_button.dart';
import 'package:avzag/phonology/phoneme/phoneme_card.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/column_tile.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class PhonologyPage extends StatefulWidget {
  @override
  _PhonologyPageState createState() => _PhonologyPageState();
}

class _PhonologyPageState extends State<PhonologyPage> {
  late MapEntry<String, Map<String, Phoneme>> phoneme;
  int page = 0;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    phoneme = PhonologyStore.phonemes.entries.first;
    _pageController.addListener(() {
      final page = _pageController.page?.round();
      if (page != null && page != this.page)
        setState(() {
          this.page = page;
        });
    });
  }

  @override
  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void openPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: standardEasing,
    );
  }

  void openEditor(Phoneme? phoneme) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (c) => EntryEditor(
    //       entry: entry,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phonology'),
      ),
      drawer: NavDraver(title: 'phonology'),
      floatingActionButton: EditorStore.language == null
          ? null
          : FloatingActionButton(
              onPressed: () => openEditor(
                page == 0 ? null : phoneme.value[EditorStore.language],
              ),
              child: Icon(
                page == 0 ? Icons.add_outlined : Icons.edit_outlined,
              ),
              tooltip: page == 0 ? 'Add new phoneme' : 'Edit this phoneme',
            ),
      body: PageView(
        controller: _pageController,
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 80,
              childAspectRatio: 1.25,
            ),
            itemCount: PhonologyStore.phonemes.length,
            itemBuilder: (_, i) {
              final p = PhonologyStore.phonemes.entries.elementAt(i);
              return PhonemeButton(
                p.key,
                onTap: () {
                  setState(() {
                    phoneme = p;
                  });
                  openPage(1);
                },
              );
            },
          ),
          Column(
            children: [
              ColumnTile(
                Text(
                  phoneme.key,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: 'Phoneme Tags will be here.',
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_outlined,
                    color: Colors.black,
                  ),
                  onPressed: () => openPage(0),
                ),
                gap: 20,
                padding: const EdgeInsets.symmetric(horizontal: 4),
              ),
              Divider(height: 0),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (_, i) {
                    final p = phoneme.value.entries.elementAt(i);
                    return PhonemeCard(
                      p.value,
                      language: p.key,
                      playing: SoundManager.url,
                      onPlay: (url) => SoundManager.playUrl(
                        url,
                        onStart: () => setState(() {}),
                      ).then(
                        (_) => setState(() {}),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => Divider(
                    height: 0,
                  ),
                  itemCount: phoneme.value.length,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
