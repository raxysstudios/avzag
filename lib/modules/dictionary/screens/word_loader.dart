import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/models/word.dart';
import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/modules/dictionary/services/word.dart';
import 'package:avzag/modules/navigation/screens/loader.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:flutter/material.dart';

class WordLoaderScreen extends StatelessWidget {
  const WordLoaderScreen(
    @pathParam this.id, {
    Key? key,
  }) : super(key: key);

  final String id;

  @override
  Widget build(BuildContext context) {
    return LoaderScreen<Word>(
      loadWord(id),
      then: (context, w) async {
        if (w == null) {
          return const DictionaryRoute();
        } else {
          await context.router.pushNativeRoute<void>(
            MaterialPageRoute(
              builder: (context) => WordScreen(w),
            ),
          );
          return null;
        }
      },
    );
  }
}
