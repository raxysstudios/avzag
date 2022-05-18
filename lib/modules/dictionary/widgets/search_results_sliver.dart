import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/column_card.dart';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/entry.dart';
import '../search_controller.dart';
import 'entry_tile.dart';

class SearchResultsSliver extends StatelessWidget {
  const SearchResultsSliver(
    this.search,
    this.paging, {
    this.onTap,
    Key? key,
  }) : super(key: key);

  final SearchController search;
  final PagingController<int, String> paging;
  final ValueSetter<Entry>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return PagedSliverList(
      pagingController: paging,
      builderDelegate: PagedChildBuilderDelegate<String>(
        itemBuilder: (context, id, _) {
          final hitGroups = search.getHits(id);
          final tags = search.getTags(id);
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
                      capitalize(hitGroups.first.first.term),
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
                  for (final group in hitGroups)
                    Column(
                      children: [
                        for (var i = 0; i < group.length; i++)
                          EntryTile(
                            group[i],
                            showLanguage: !search.monolingual && i == 0,
                            onTap: onTap == null
                                ? null
                                : () => onTap!(
                                      group[i],
                                    ),
                          ),
                      ],
                    )
                ],
              ),
            ],
          );
        },
        noItemsFoundIndicatorBuilder: _buildEndCaption,
        noMoreItemsIndicatorBuilder: _buildEndCaption,
      ),
    );
  }

  Widget _buildEndCaption(BuildContext context) {
    return Caption(
      search.monolingual ? 'End of results' : 'Showing first 50 entries',
      icon: Icons.done_all_rounded,
    );
  }
}
