import 'package:avzag/models/entry.dart';
import 'package:avzag/shared/extensions.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
          child: Row(
            textBaseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                groups.first.first.term.titled,
                style: TextStyle(
                  color: theme.caption?.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (tags.isNotEmpty)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      tags.join(', '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.caption,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          elevation: .5,
          child: Column(
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
        ),
      ],
    );
  }
}
