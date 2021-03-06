import 'package:auto_route/auto_route.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/modules/dictionary/widgets/word_view.dart';
import 'package:bazur/shared/widgets/caption.dart';
import 'package:bazur/shared/widgets/language_title.dart';
import 'package:bazur/shared/widgets/options_button.dart';
import 'package:flutter/material.dart';

import 'services/word.dart';

class WordsDiffScreen extends StatelessWidget {
  const WordsDiffScreen(
    this.base,
    this.overwrite, {
    Key? key,
  }) : super(key: key);

  final Word? base;
  final Word overwrite;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: LanguageTitle(overwrite.language),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.onSurface,
            tabs: [
              Tab(
                child: OptionItem.simple(
                  Icons.adjust_outlined,
                  'Base',
                  centered: true,
                ).widget,
              ),
              Tab(
                child: OptionItem.simple(
                  Icons.edit_outlined,
                  'Overwrite',
                  centered: true,
                ).widget,
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => deleteWord(
                context,
                overwrite.id!,
                after: context.popRoute,
                title: 'Reject the contribution?',
              ),
              icon: const Icon(Icons.delete_outlined),
              tooltip: 'Reject',
            ),
            const SizedBox(width: 4),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.upload_outlined),
          onPressed: () async => acceptContribution(
            context,
            overwrite,
            after: context.popRoute,
          ),
        ),
        body: TabBarView(
          children: [
            base == null
                ? const Center(
                    child: Caption(
                      'No base word',
                      icon: Icons.highlight_off_outlined,
                    ),
                  )
                : WordView(base!),
            WordView(overwrite),
          ],
        ),
      ),
    );
  }
}
