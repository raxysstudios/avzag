import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/widgets/samples_editor.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/modals/danger_dialog.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/compact_input.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/use.dart';
import '../models/word.dart';
import '../services/word.dart';

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
        leading: const RoundedBackButton(),
        title: Text(word.language.titled),
        actions: [
          Opacity(
            opacity: .5,
            child: LanguageFlag(
              word.language,
              width: 160,
              offset: const Offset(16, -2),
              scale: 1.25,
            ),
          ),
          OptionsButton(
            [
              OptionItem.simple(
                Icons.close_rounded,
                'Discard',
                onTap: exit,
              ),
              if (word.id.isNotEmpty && EditorStore.admin)
                OptionItem.simple(
                  Icons.delete_rounded,
                  'Delete',
                  onTap: () => deleteWord(
                    context,
                    word.id,
                    after: exit,
                  ),
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
                  Icons.bookmark_rounded,
                  'Headword',
                  word.headword,
                  (s) => word.headword = s,
                  noEmpty: true,
                ),
                CompactInput(
                  Icons.volume_up_rounded,
                  'IPA',
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
                  Icons.note_rounded,
                  'General note',
                  word.note,
                  (s) => word.note = s,
                  lowercase: false,
                ),
              ],
            ),
            SamplesEditor('Add a form', word.forms),
            for (final u in word.uses) ...[
              ColumnCard(
                key: Key(u.term),
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
                        'Delete the use?',
                      ),
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  ),
                  CompactInput(
                    Icons.label_rounded,
                    'Aliases',
                    u.aliases.join(' '),
                    (s) => u.aliases = s.split(' '),
                  ),
                  CompactInput(
                    Icons.tag_rounded,
                    'Semantic tags',
                    u.tags.join(' '),
                    (s) => u.tags = s.split(' '),
                  ),
                  CompactInput(
                    Icons.note_rounded,
                    'Usage note',
                    u.note,
                    (s) => u.note = s,
                    lowercase: false,
                  ),
                ],
              ),
              SamplesEditor('Add an example', u.examples),
            ],
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton.icon(
                onPressed: () => setState(() {
                  word.uses.add(
                    Use(
                      '',
                      aliases: [],
                      tags: [],
                      examples: [],
                    ),
                  );
                }),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add a use'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
