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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final hits = this.hits[index];
          EntryHit? lastHit;
          return Card(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: hits.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final hit = hits[index];
                final language = hit.language != lastHit?.language;
                final divider = language && lastHit != null;
                lastHit = hit;

                final tile = HitTile(
                  hit,
                  showLanguage: language,
                  onTap: onTap == null ? null : () => onTap!(hit),
                );
                if (divider) {
                  return Column(
                    children: [
                      const Divider(height: 0),
                      tile,
                    ],
                  );
                }
                return tile;
              },
            ),
          );
        },
        childCount: hits.length,
      ),
    );
  }
}
