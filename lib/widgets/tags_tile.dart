import 'package:avzag/global_store.dart';
import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';

class TagsTile extends StatelessWidget {
  const TagsTile(
    this.tags, {
    Key? key,
    this.onEdited,
    this.algoliaIndex = 'dictionary',
  }) : super(key: key);

  final List<String>? tags;
  final ValueSetter<List<String>?>? onEdited;
  final String? algoliaIndex;

  @override
  Widget build(BuildContext context) {
    if (tags == null && onEdited == null) return const Offstage();
    return ListTile(
      minVerticalPadding: 12,
      leading: const Icon(Icons.tag_outlined),
      title: (tags?.isEmpty ?? true)
          ? Text(
              'Tap to add tags',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.caption?.color,
              ),
            )
          : Text(
              prettyTags(
                tags,
                capitalized: false,
              )!,
            ),
      onTap: onEdited == null ? null : () => showEditor(context),
      onLongPress: onEdited == null
          ? () => copyText(
                context,
                tags!.join(' '),
              )
          : null,
    );
  }

  void showEditor(BuildContext context) {
    var result = [...tags ?? []];
    final index =
        algoliaIndex == null ? null : GlobalStore.algolia.index(algoliaIndex!);
    var suggested = <String>[];
    final controller = TextEditingController(text: tags?.join(' '));

    final form = GlobalKey<FormState>();
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit tags'),
          content: SingleChildScrollView(
            child: Form(
              key: form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: controller,
                        autofocus: true,
                        onChanged: (value) async {
                          result = value
                              .trim()
                              .split(' ')
                              .where((e) => e.isNotEmpty)
                              .toList();
                          if (index != null) {
                            final hits = await index.facetQuery(
                              'tags',
                              facetQuery: result.isEmpty || value.endsWith(' ')
                                  ? ''
                                  : result.last,
                            );
                            setState(() {
                              suggested = hits.map((h) => h.value).toList();
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Space-separated, without #',
                        ),
                        validator: emptyValidator,
                        inputFormatters: [LowerCaseTextFormatter()],
                      ),
                      if (index != null) ...[
                        const Text('Frequent tags'),
                        ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            for (final t in suggested)
                              InputChip(
                                label: Text(t),
                                onPressed: () {
                                  final base = result.isEmpty ||
                                          controller.text.endsWith(' ')
                                      ? result
                                      : result.sublist(0, result.length - 1);
                                  controller.text = [...base, t].join(' ');
                                },
                              ),
                          ],
                        ),
                      ]
                    ],
                  );
                },
              ),
            ),
          ),
          actions: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onEdited!(null);
                  },
                  icon: const Icon(Icons.delete_outlined),
                  color: theme.colorScheme.error,
                  splashColor: theme.colorScheme.error.withOpacity(0.1),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_outlined),
                  label: const Text('Cancel'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(theme.hintColor),
                    overlayColor: MaterialStateProperty.all(
                      theme.hintColor.withOpacity(0.1),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    if (form.currentState?.validate() ?? false) {
                      Navigator.pop(context);
                      onEdited!(result);
                    }
                  },
                  icon: const Icon(Icons.done_outlined),
                  label: const Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
