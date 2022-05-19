import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

import '../models/word.dart';
import '../services/word.dart';

class WordsDiffScreen extends StatefulWidget {
  const WordsDiffScreen(
    this.base,
    this.overwrite, {
    this.scroll,
    Key? key,
  }) : super(key: key);

  final Word? base;
  final Word overwrite;
  final ScrollController? scroll;

  @override
  State<WordsDiffScreen> createState() => _WordsDiffScreenState();
}

class _WordsDiffScreenState extends State<WordsDiffScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(
            icon: Icons.close_rounded,
          ),
          title: Text(capitalize(EditorStore.language)),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.adjust_rounded),
                text: 'Base',
              ),
              Tab(
                icon: Icon(Icons.edit_rounded),
                text: 'Overwrite',
              ),
            ],
          ),
          actions: [
            Opacity(
              opacity: .5,
              child: LanguageFlag(
                widget.overwrite.language,
                width: 160,
                offset: const Offset(16, -2),
                scale: 1.25,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.delete_forever),
              tooltip: 'Reject',
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.upload_rounded),
          onPressed: () async => acceptContribution(
            context,
            widget.overwrite,
            () => Navigator.pop(context),
          ),
        ),
        body: TabBarView(
          children: [
            widget.base == null
                ? Center(
                    child: Caption(
                      'No base word',
                      icon: Icons.highlight_off_rounded,
                    ),
                  )
                : WordScreen(
                    widget.base!,
                    embedded: true,
                  ),
            WordScreen(
              widget.overwrite,
              embedded: true,
            ),
          ],
        ),
      ),
    );
  }
}
