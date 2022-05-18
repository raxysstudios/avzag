import 'package:avzag/shared/utils/text.dart';
import 'package:flutter/material.dart';
import '../models/sample.dart';

class SamplesList extends StatelessWidget {
  const SamplesList(
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
                  if (s.translation != null)
                    inline ? s.translation!.toUpperCase() : s.translation,
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
                      TextSpan(text: s.text),
                      if (s.translation != null) ...[
                        TextSpan(text: inline ? ' ' : '\n'),
                        TextSpan(
                          text: inline
                              ? s.translation!.toUpperCase()
                              : s.translation,
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
