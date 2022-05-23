import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/span_icon.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              Icons.unpublished_rounded,
              padding: EdgeInsets.only(right: 4),
            ),
          Text(
            capitalize(hit.headword),
            style: GoogleFonts.robotoSlab(
              textStyle: theme.subtitle1,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hit.form != null && hit.form != hit.headword)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                capitalize(hit.form!),
                style: GoogleFonts.robotoSlab(
                  textStyle: theme.subtitle1,
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
