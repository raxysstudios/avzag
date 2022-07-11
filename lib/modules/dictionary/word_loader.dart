import 'package:auto_route/auto_route.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/modules/dictionary/services/word.dart';
import 'package:bazur/navigation/loader.dart';
import 'package:bazur/navigation/router.gr.dart';
import 'package:flutter/material.dart';

class WordLoaderScreen extends StatelessWidget {
  const WordLoaderScreen(
    @pathParam this.id, {
    this.onEdit,
    Key? key,
  }) : super(key: key);

  final String id;
  final void Function(Word)? onEdit;

  @override
  Widget build(BuildContext context) {
    return LoaderScreen<Word>(
      loadWord(id),
      requiredStack: [
        const DictionaryRoute(),
        WordLoaderRoute(id: id),
      ],
      then: (context, word) async {
        final router = context.router;
        if (word == null) {
          router.navigate(const RootRoute());
        } else {
          final router = context.router;
          await router.replace(
            WordRoute(
              word: word,
              id: word.id,
              onEdit: onEdit,
            ),
          );
          if (router.stack.length < 2) {
            router.navigate(const RootRoute());
          }
        }
      },
    );
  }
}
