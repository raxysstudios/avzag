import 'package:avzag/global_store.dart';
import 'package:avzag/modules/dictionary/widgets/samples_editor.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/compact_input.dart';
import 'package:avzag/shared/widgets/modals/danger_dialog.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';

import '../models/use.dart';
import '../models/word.dart';
import '../services/word.dart';

class WordEditorScreen extends StatefulWidget {
  const WordEditorScreen(
    this.word, {
    this.scroll,
    this.onDone,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ScrollController? scroll;
  final VoidCallback? onDone;

  @override
  State<WordEditorScreen> createState() => _WordEditorScreenState();
}

class _WordEditorScreenState extends State<WordEditorScreen> {
  final form = GlobalKey<FormState>();

  Word get word => widget.word;
  bool get isReviewing =>
      EditorStore.isAdmin &&
      word.language == EditorStore.language &&
      word.contribution != null;

  void exit() {
    Navigator.pop(context);
    widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(),
        title: Text(capitalize(EditorStore.language)),
        actions: [
          if (EditorStore.isAdmin)
            OptionsButton(
              [
                if (!isReviewing)
                  OptionItem.simple(
                    Icons.cancel_rounded,
                    'Discard',
                    exit,
                  ),
                if (word.id != null)
                  OptionItem.simple(
                    Icons.delete_forever_rounded,
                    'Delete',
                    () => deleteWord(context, word.id!, exit),
                  ),
              ],
            ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_rounded),
        onPressed: () async {
          if (form.currentState?.validate() ?? false) {
            submitWord(context, word, exit);
          }
        },
      ),
      body: Form(
        key: form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          controller: widget.scroll,
          padding: const EdgeInsets.only(bottom: 76),
          children: [
            ColumnCard(
              divider: null,
              children: [
                CompactInput(
                  Icons.bookmark_rounded,
                  'Headword',
                  word.headword,
                  (s) => word.headword = s,
                  noEmpty: true,
                ),
                CompactInput(
                  Icons.volume_up_rounded,
                  'Headword IPA',
                  word.ipa,
                  (s) => word.ipa = s,
                ),
                CompactInput(
                  Icons.tag_rounded,
                  'Form tags',
                  word.tags.join(' '),
                  (s) => word.tags = s.split(' '),
                ),
                CompactInput(
                  Icons.info_rounded,
                  'General note',
                  word.note,
                  (s) => word.note = s,
                  lowercase: false,
                ),
              ],
            ),
            SamplesEditor(Icons.layers_rounded, 'Forms', word.forms),
            for (final u in word.uses)
              ColumnCard(
                divider: null,
                children: [
                  CompactInput(
                    Icons.lightbulb_rounded,
                    'Term',
                    u.term,
                    (s) => u.term = s,
                    noEmpty: true,
                    trailing: IconButton(
                      onPressed: () => showDangerDialog(
                        context,
                        () => setState(() {
                          word.uses.remove(u);
                        }),
                        'Delete this use?',
                      ),
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  ),
                  CompactInput(
                    Icons.label_rounded,
                    'Aliases',
                    u.aliases?.join(' '),
                    (s) => u.aliases = s.split(' '),
                  ),
                  CompactInput(
                    Icons.tag_rounded,
                    'Semantic tags',
                    u.tags?.join(' '),
                    (s) => u.tags = s.split(' '),
                  ),
                  CompactInput(
                    Icons.info_rounded,
                    'Usage note',
                    u.note,
                    (s) => u.note = s,
                    lowercase: false,
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => setState(() {
                  word.uses.add(Use(''));
                }),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add use'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
