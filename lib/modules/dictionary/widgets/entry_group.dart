import 'package:avzag/modules/dictionary/models/entry.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:flutter/material.dart';

import 'entry_tile.dart';

class EntryGroup extends StatelessWidget {
  const EntryGroup(
    this.groups, {
    this.onTap,
    this.showLanguage = true,
    Key? key,
  }) : super(key: key);

  final bool showLanguage;
  final List<List<Entry>> groups;
  final ValueSetter<Entry>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final tags = groups
        .map((g) => g.map((e) => e.tags ?? []).expand((e) => e))
        .expand((e) => e)
        .toSet();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                capitalize(groups.first.first.term),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (tags.isNotEmpty)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      prettyTags(
                        tags,
                        separator: ' ',
                        capitalized: false,
                      )!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.caption,
                    ),
                  ),
                ),
            ],
          ),
        ),
        ColumnCard(
          margin: EdgeInsets.zero,
          children: [
            for (final g in groups)
              Column(
                children: [
                  for (var i = 0; i < g.length; i++)
                    EntryTile(
                      g[i],
                      showLanguage: showLanguage && i == 0,
                      onTap: () => onTap?.call(g[i]),
                    ),
                ],
              )
          ],
        ),
      ],
    );
  }
}
