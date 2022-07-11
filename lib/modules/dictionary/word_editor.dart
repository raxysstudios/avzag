import 'package:auto_route/auto_route.dart';
import 'package:bazur/models/use.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/modules/dictionary/widgets/samples_editor.dart';
import 'package:bazur/shared/modals/danger_dialog.dart';
import 'package:bazur/shared/widgets/column_card.dart';
import 'package:bazur/shared/widgets/compact_input.dart';
import 'package:bazur/shared/widgets/language_title.dart';
import 'package:bazur/shared/widgets/options_button.dart';
import 'package:bazur/store.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'services/word.dart';

class WordEditorScreen extends StatefulWidget {
  const WordEditorScreen(
    this.word, {
    this.onDone,
    Key? key,
  }) : super(key: key);

  final Word word;
  final VoidCallback? onDone;

  @override
  State<WordEditorScreen> createState() => _WordEditorScreenState();
}

class _WordEditorScreenState extends State<WordEditorScreen> {
  final form = GlobalKey<FormState>();
  late final word = widget.word;

  void exit() {
    context.popRoute();
    widget.onDone?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: LanguageTitle(word.language),
        actions: [
          OptionsButton(
            [
              OptionItem.simple(
                Icons.cancel_outlined,
                'Discard',
                onTap: exit,
              ),
              if (word.id != null && EditorStore.admin)
                OptionItem.simple(
                  Icons.delete_outlined,
                  'Delete',
                  onTap: () => deleteWord(
                    context,
                    word.id!,
                    after: exit,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.upload_outlined),
        onPressed: () async {
          if (form.currentState?.validate() ?? false) {
            submitWord(
              context,
              word,
              after: exit,
            );
          }
        },
      ),
      body: Form(
        key: form,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          controller: ModalScrollController.of(context),
          padding: const EdgeInsets.only(bottom: 76),
          children: [
            ColumnCard(
              divider: null,
              children: [
                CompactInput(
                  Icons.label_important_outlined,
                  'Headword',
                  word.headword,
                  (s) => word.headword = s,
                  noEmpty: true,
                ),
                CompactInput(
                  Icons.volume_up_outlined,
                  'IPA',
                  word.ipa,
                  (s) => word.ipa = s,
                ),
                CompactInput(
                  Icons.tag_outlined,
                  'Form tags',
                  word.tags.join(' '),
                  (s) => word.tags = s.split(' '),
                ),
                CompactInput(
                  Icons.sticky_note_2_outlined,
                  'General note',
                  word.note,
                  (s) => word.note = s,
                  multiline: true,
                  lowercase: false,
                ),
              ],
            ),
            SamplesEditor('Add a form', word.forms),
            for (final d in word.definitions) ...[
              ColumnCard(
                key: ObjectKey(d),
                divider: null,
                children: [
                  CompactInput(
                    Icons.lightbulb_outlined,
                    'Translation',
                    d.translation,
                    (s) => d.translation = s,
                    noEmpty: true,
                    trailing: IconButton(
                      onPressed: () => showDangerDialog(
                        context,
                        () => setState(() {
                          word.definitions.remove(d);
                        }),
                        'Delete the definition?',
                      ),
                      icon: const Icon(Icons.delete_outlined),
                    ),
                  ),
                  CompactInput(
                    Icons.label_outlined,
                    'Aliases',
                    d.aliases.join(' '),
                    (s) => d.aliases = s.split(' '),
                  ),
                  CompactInput(
                    Icons.tag_outlined,
                    'Semantic tags',
                    d.tags.join(' '),
                    (s) => d.tags = s.split(' '),
                  ),
                  CompactInput(
                    Icons.sticky_note_2_outlined,
                    'Usage note',
                    d.note,
                    (s) => d.note = s,
                    lowercase: false,
                    multiline: true,
                  ),
                ],
              ),
              SamplesEditor('Add an example', d.examples),
            ],
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () => setState(() {
                  word.definitions.add(
                    Definition(
                      '',
                      aliases: [],
                      tags: [],
                      examples: [],
                    ),
                  );
                }),
                icon: const Icon(Icons.add_outlined),
                label: const Text('Add a definition'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
