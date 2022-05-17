import 'package:avzag/global_store.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/editor_dialog.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';

import '../models/use.dart';
import '../models/word.dart';
import '../services/word.dart';

class WordEditorScreen extends StatefulWidget {
  const WordEditorScreen(
    this.word, {
    Key? key,
  }) : super(key: key);

  final Word? word;

  @override
  State<WordEditorScreen> createState() => _WordEditorScreenState();
}

class _WordEditorScreenState extends State<WordEditorScreen> {
  late final Word word;
  final form = GlobalKey<FormState>();

  bool get isReviewing =>
      EditorStore.isAdmin &&
      word.language == EditorStore.language &&
      word.contribution != null;

  @override
  void initState() {
    super.initState();
    word = widget.word ??
        Word(
          headword: '',
          uses: [],
          language: EditorStore.language!,
        );
  }

  void exit() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(),
        title: Row(
          children: [
            const Icon(Icons.edit_rounded),
            const SizedBox(width: 16),
            Text(capitalize(EditorStore.language))
          ],
        ),
        actions: [
          if (EditorStore.isAdmin)
            OptionsButton(
              [
                if (!isReviewing)
                  OptionItem.simple(
                    Icons.cancel_rounded,
                    'Discard',
                    () => exit(),
                  ),
                if (word.id != null)
                  OptionItem.simple(
                    Icons.delete_rounded,
                    'Delete',
                    () => deleteWord(context, word.id!).then((_) => exit()),
                  ),
              ],
              icon: const Icon(Icons.done_all_rounded),
            ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done_all_rounded),
        onPressed: () async {
          if (form.currentState?.validate() ?? false) {
            submitWord(context, word).then((_) => exit());
          }
        },
      ),
      body: Form(
        key: form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.only(bottom: 76),
          children: [
            ListTile(
              leading: const Icon(Icons.tag_rounded),
              title: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Form tags',
                ),
                initialValue: word.tags?.join(' '),
                inputFormatters: [LowerCaseTextFormatter()],
                onChanged: (s) => word.tags = s.trim().split(' '),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_rounded),
              title: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'General note',
                ),
                initialValue: word.note,
                inputFormatters: [LowerCaseTextFormatter()],
                onChanged: (s) => word.note = s.trim(),
              ),
            ),
            for (final use in word.uses)
              ColumnCard(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lightbulb_rounded),
                    title: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Term',
                      ),
                      initialValue: use.term,
                      validator: emptyValidator,
                      inputFormatters: [LowerCaseTextFormatter()],
                      onChanged: (s) => use.term = s.trim(),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.label_rounded),
                    title: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Aliases',
                      ),
                      initialValue: use.aliases?.join(' '),
                      inputFormatters: [LowerCaseTextFormatter()],
                      onChanged: (s) => use.aliases = s.trim().split(' '),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tag_rounded),
                    title: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Semantic tags',
                      ),
                      initialValue: use.tags?.join(' '),
                      inputFormatters: [LowerCaseTextFormatter()],
                      onChanged: (s) => use.tags = s.trim().split(' '),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.info_rounded),
                    title: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Note',
                      ),
                      initialValue: use.note,
                      inputFormatters: [LowerCaseTextFormatter()],
                      onChanged: (s) => use.note = s.trim(),
                    ),
                  ),
                ],
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
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
