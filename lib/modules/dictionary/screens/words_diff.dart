import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';

import '../models/word.dart';
import '../services/word.dart';

class WordsDiffScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: RoundedBackButton(
            icon: Icons.close_rounded,
          ),
          title: Text(overwrite.language.titled),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.onSurface,
            tabs: [
              Tab(
                child: OptionItem.simple(
                  Icons.adjust_rounded,
                  'Base',
                  centered: true,
                ).widget,
              ),
              Tab(
                child: OptionItem.simple(
                  Icons.edit_rounded,
                  'Overwrite',
                  centered: true,
                ).widget,
              ),
            ],
          ),
          actions: [
            Opacity(
              opacity: .5,
              child: LanguageFlag(
                overwrite.language,
                width: 160,
                offset: const Offset(16, -2),
                scale: 1.25,
              ),
            ),
            IconButton(
              onPressed: () => deleteWord(
                context,
                overwrite.id!,
                after: () => Navigator.pop(context),
                title: 'Reject the contribution?',
              ),
              icon: Icon(Icons.delete_forever),
              tooltip: 'Reject',
            ),
            const SizedBox(width: 4),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.upload_rounded),
          onPressed: () async => acceptContribution(
            context,
            overwrite,
            after: () => Navigator.pop(context),
          ),
        ),
        body: TabBarView(
          children: [
            base == null
                ? Center(
                    child: Caption(
                      'No base word',
                      icon: Icons.highlight_off_rounded,
                    ),
                  )
                : WordScreen(
                    base!,
                    embedded: true,
                  ),
            WordScreen(
              overwrite,
              embedded: true,
            ),
          ],
        ),
      ),
    );
  }
}
