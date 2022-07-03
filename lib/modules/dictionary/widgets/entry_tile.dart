import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/span_icon.dart';

import 'package:flutter/material.dart';

import '../models/entry.dart';

class EntryTile extends StatelessWidget {
  final Entry hit;
  final bool showLanguage;
  final VoidCallback? onTap;

  const EntryTile(
    this.hit, {
    this.showLanguage = true,
    this.onTap,
    Key? key,
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
              Icons.unpublished_outlined,
              padding: EdgeInsets.only(right: 8),
            ),
          Text(
            hit.headword.titled,
            style: styleNative.copyWith(
              fontSize: theme.subtitle1?.fontSize,
            ),
          ),
          if (hit.form != null && hit.form != hit.headword)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                hit.form!.titled,
                style: styleNative.copyWith(
                  fontSize: theme.subtitle1?.fontSize,
                  color: theme.caption?.color,
                ),
              ),
            ),
          const Spacer(),
          if (showLanguage)
            Text(
              hit.language.titled,
              style: theme.caption,
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
