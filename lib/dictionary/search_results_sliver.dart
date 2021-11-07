import 'dart:ui';

import 'package:avzag/widgets/span_icon.dart';
import 'package:flutter/material.dart';
import 'package:avzag/utils/utils.dart';

import 'hit_tile.dart';
import 'search_controller.dart';

class SearchResultsSliver extends StatelessWidget {
  const SearchResultsSliver(
    this.search, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final SearchController search;
  final ValueSetter<EntryHit>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final id = search.getId(index);
          final hitGroups = search.getHits(index);
          final tags = search.getTags(index);
          return Column(
            children: [
              const SizedBox(height: 8),
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: theme.textTheme.caption?.copyWith(
                    fontSize: 14,
                  ),
                  children: [
                    const WidgetSpan(child: SizedBox(width: 20)),
                    TextSpan(
                      text: capitalize(id),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const WidgetSpan(
                      child: SpanIcon(
                        Icons.tag_outlined,
                        padding: EdgeInsets.only(left: 4, right: 2),
                      ),
                    ),
                    TextSpan(
                      text: prettyTags(
                        tags,
                        separator: ' ',
                        capitalized: false,
                      ),
                    ),
                  ],
                ),
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
                        if (index > 0) const Divider(),
                        for (var i = 0; i < hits.length; i++)
                          HitTile(
                            hits[i],
                            showLanguage: i == 0,
                            onTap: onTap == null ? null : () => onTap!(hits[i]),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
        childCount: search.length,
      ),
    );
  }
}
