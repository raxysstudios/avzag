import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/span_icon.dart';

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
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.caption?.copyWith(
                          fontSize: 14,
                        ),
                    children: [
                      TextSpan(
                        text: capitalize(hitGroups.first.first.term),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const WidgetSpan(
                        child: SpanIcon(
                          Icons.tag_rounded,
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
      search.monolingual ? 'End of results' : 'Shown first 50 results',
      icon: Icons.check_rounded,
    );
  }
}
