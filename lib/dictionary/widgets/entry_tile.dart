import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/span_icon.dart';

import 'package:flutter/material.dart';

import '../models/entry.dart';

class EntryTile extends StatelessWidget {
  final Entry hit;
  final bool showLanguage;
  final VoidCallback? onTap;

  const EntryTile(
    this.hit, {
    Key? key,
    this.showLanguage = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      title: Row(
        children: [
          if (hit.unverified)
            const SpanIcon(
              Icons.unpublished_rounded,
              padding: EdgeInsets.only(right: 4),
            ),
          Text(
            capitalize(hit.headword),
            style: theme.subtitle1?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hit.form != null && hit.form != hit.headword)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                capitalize(hit.form!),
                style: theme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.caption?.color,
                ),
              ),
            ),
          const Spacer(),
          if (showLanguage)
            Text(
              capitalize(hit.language),
              style: theme.caption,
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
