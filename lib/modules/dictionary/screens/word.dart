import 'package:avzag/global_store.dart';
import 'package:avzag/modules/dictionary/widgets/samples_list.dart';
import 'package:avzag/shared/utils/utils.dart';
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
        title: Text(capitalize(word.language)),
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
            title: capitalize(word.headword),
            altTitle: word.ipa == null ? null : '/ ${word.ipa} /',
            subtitle: prettyTags(word.tags),
            body: word.note,
          ),
          if (word.forms != null)
            SamplesList(
              word.forms!.skip(1),
              inline: true,
            ),
          for (final u in word.uses) ...[
            Segment(
              title: capitalize(u.term),
              subtitle: prettyTags(u.tags),
              body: u.note,
            ),
            if (u.samples != null) SamplesList(u.samples!),
          ],
        ],
      ),
    );
  }
}
