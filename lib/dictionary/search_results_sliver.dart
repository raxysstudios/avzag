import 'dart:ui';

import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';
import 'search_results.dart';

class SearchResultsSliver extends StatelessWidget {
  final SearchResults results;
  final ValueSetter<EntryHit>? onTap;

  const SearchResultsSliver(
    this.results, {
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        iconTheme: IconThemeData(
          color: theme.textTheme.caption?.color,
          size: 16,
        ),
      ),
      child: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final id = results.ids[index];
            final hitGroups = results[index];
            final tags = results.tags[id]!;
            return Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    const SizedBox(width: 2),
                    const Icon(Icons.lightbulb_outlined),
                    const SizedBox(width: 2),
                    Text(
                      capitalize(id),
                      style: theme.textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    if (tags.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.tag_outlined),
                      const SizedBox(width: 2),
                      Text(
                        prettyTags(
                          tags,
                          separator: ' ',
                          capitalized: false,
                        )!,
                        style: theme.textTheme.caption?.copyWith(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ],
                ),
                Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: hitGroups.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final hits = hitGroups[index];
                      return Column(
                        children: [
                          if (index > 0) const Divider(height: 0),
                          for (var i = 0; i < hits.length; i++)
                            HitTile(
                              hits[i],
                              showLanguage: i == 0,
                              onTap:
                                  onTap == null ? null : () => onTap!(hits[i]),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
          childCount: results.length,
        ),
      ),
    );
  }
}
