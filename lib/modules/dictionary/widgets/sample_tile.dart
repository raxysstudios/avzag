import 'package:flutter/material.dart';
import '../models/sample.dart';

class SamplesText extends StatelessWidget {
  const SamplesText(
    this.samples, {
    this.inline = false,
    Key? key,
  }) : super(key: key);

  final List<Sample> samples;
  final bool inline;

  @override
  Widget build(BuildContext context) {
    final caption = Theme.of(context).textTheme.caption;
    return Column(
      children: [
        for (var i = 0; i < samples.length; i++)
          Builder(builder: (context) {
            final s = samples[i];
            return InkWell(
              child: Row(
                children: [
                  Text(
                    i.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (inline) ...[
                    Text(s.text),
                    const Spacer(),
                    if (s.translation != null)
                      Text(
                        s.translation!,
                        style: caption,
                      ),
                  ]
                ],
              ),
            );
          }),
      ],
    );
  }
}
