import 'package:avzag/shared/utils/text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/sample.dart';

class SamplesColumn extends StatelessWidget {
  const SamplesColumn(
    this.samples, {
    this.inline = false,
    this.padding = const EdgeInsets.only(top: 4),
    Key? key,
  }) : super(key: key);

  final EdgeInsets padding;
  final Iterable<Sample> samples;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final s in samples)
            InkWell(
              onLongPress: () {
                final text = [
                  s.text,
                  if (s.meaning != null)
                    inline ? s.meaning!.toUpperCase() : s.meaning
                ].join(inline ? ' ' : '\n');
                copyText(context, text);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: RichText(
                  text: TextSpan(
                    style: theme.bodyText2,
                    children: [
                      TextSpan(
                        text: s.text,
                        style: GoogleFonts.robotoSlab(),
                      ),
                      if (s.meaning != null) ...[
                        TextSpan(text: inline ? ' ' : '\n'),
                        TextSpan(
                          text: inline ? s.meaning!.toUpperCase() : s.meaning,
                          style: TextStyle(color: theme.caption?.color),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
