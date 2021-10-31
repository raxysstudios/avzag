import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class SearchResultsSliver extends StatelessWidget {
  final List<List<EntryHit>> hits;
  final ValueSetter<EntryHit>? onTap;

  const SearchResultsSliver(
    this.hits, {
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
            final hits = this.hits[index];
            final tags = <String>{...hits.expand((h) => h.tags ?? [])};
            EntryHit? lastHit;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 8),
                  child: Row(
                    children: [
                      Text(
                        capitalize(hits[0].id),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.tag_outlined),
                        const SizedBox(width: 4),
                        Text(
                          prettyTags(
                            tags,
                            separator: ' ',
                            capitalized: false,
                          )!,
                          style: const TextStyle(fontSize: 14),
                          maxLines: 1,
                        ),
                      ],
                    ],
                  ),
                ),
                Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    itemCount: hits.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final hit = hits[index];
                      final language = hit.language != lastHit?.language;
                      final divider = language && lastHit != null;
                      final tile = HitTile(
                        hit,
                        showLanguage: language,
                        onTap: onTap == null ? null : () => onTap!(hit),
                      );

                      lastHit = hit;
                      return divider
                          ? Column(
                              children: [
                                const Divider(height: 0),
                                tile,
                              ],
                            )
                          : tile;
                    },
                  ),
                ),
              ],
            );
          },
          childCount: hits.length,
        ),
      ),
    );
  }
}
