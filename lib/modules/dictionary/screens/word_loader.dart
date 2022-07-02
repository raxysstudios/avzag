import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/models/word.dart';
import 'package:avzag/modules/dictionary/services/word.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/modals/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WordLoaderScreen extends StatefulWidget {
  const WordLoaderScreen(
    @pathParam this.id, {
    this.onEdit,
    Key? key,
  }) : super(key: key);

  final String id;
  final void Function(Word)? onEdit;

  @override
  State<WordLoaderScreen> createState() => _WordLoaderScreenState();
}

class _WordLoaderScreenState extends State<WordLoaderScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        final word = await showLoadingDialog(
          context,
          loadWord(widget.id),
        );
        if (word != null) {
          final router = context.router;
          await router.replace(
            WordRoute(
              word: word,
              onEdit: widget.onEdit,
            ),
          );
          if (router.stack.length < 2) {
            router.navigate(const DictionaryRoute());
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
