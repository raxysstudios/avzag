import 'package:avzag/global_store.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/danger_dialog.dart';
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

  Widget _inputField(
    IconData icon,
    String label,
    String? initial,
    ValueSetter<String> onChanged, {
    bool lowercase = true,
    bool noEmpty = false,
    Widget? trailing,
    bool multiline = false,
  }) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: trailing,
      title: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          isDense: true,
          border: InputBorder.none,
        ),
        maxLines: multiline ? 0 : null,
        initialValue: initial,
        validator: noEmpty ? emptyValidator : null,
        inputFormatters: lowercase ? [LowerCaseTextFormatter()] : null,
        onChanged: (s) => onChanged(s.trim()),
      ),
    );
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
                    () => exit(),
                  ),
                if (word.id != null)
                  OptionItem.simple(
                    Icons.delete_forever_rounded,
                    'Delete',
                    () => deleteWord(context, word.id!).then((_) => exit()),
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
            submitWord(context, word).then((_) => exit());
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
                _inputField(
                  Icons.bookmark_rounded,
                  'Headword',
                  word.headword,
                  (s) => word.headword = s,
                  noEmpty: true,
                ),
                _inputField(
                  Icons.volume_up_rounded,
                  'Headword IPA',
                  word.ipa,
                  (s) => word.ipa = s,
                ),
                _inputField(
                  Icons.tag_rounded,
                  'Form tags',
                  word.tags?.join(' '),
                  (s) => word.tags = s.split(' '),
                ),
                _inputField(
                  Icons.info_rounded,
                  'General note',
                  word.note,
                  (s) => word.note = s,
                  lowercase: false,
                ),
              ],
            ),
            for (final u in word.uses)
              ColumnCard(
                divider: null,
                children: [
                  _inputField(
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
                  _inputField(
                    Icons.label_rounded,
                    'Aliases',
                    u.aliases?.join(' '),
                    (s) => u.aliases = s.split(' '),
                  ),
                  _inputField(
                    Icons.tag_rounded,
                    'Semantic tags',
                    u.tags?.join(' '),
                    (s) => u.tags = s.split(' '),
                  ),
                  _inputField(
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
