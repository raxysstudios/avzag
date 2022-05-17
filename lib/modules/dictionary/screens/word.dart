import 'package:avzag/global_store.dart';
import 'package:avzag/modules/dictionary/widgets/sample_tile.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';

import 'package:flutter/material.dart';

import '../models/word.dart';
import '../widgets/segment.dart';

class WordScreen extends StatefulWidget {
  const WordScreen(
    this.word, {
    this.scroll,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ScrollController? scroll;

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(),
        title: LanguageFlag(
          GlobalStore.languages[word.language]!.flag,
          offset: const Offset(32, 0),
          scale: 15,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Share',
            icon: const Icon(Icons.share_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: word.language == EditorStore.language
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Edit',
              child: const Icon(Icons.edit_rounded),
            )
          : null,
      body: ListView(
        controller: widget.scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          Segment(
            title: capitalize(word.forms.first.text),
            subtitle: prettyTags(word.tags),
            body: word.note,
          ),
          SamplesText(word.forms),
          for (final u in word.uses) ...[
            Segment(
              title: capitalize(u.term),
              subtitle: prettyTags(u.tags),
              body: u.note,
            ),
            if (u.samples != null) SamplesText(u.samples!),
          ],
        ],
      ),
    );
  }
}
