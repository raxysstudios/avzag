import 'package:avzag/dictionary/models/sample.dart';
import 'package:avzag/widgets/expandable_tile.dart';
import 'package:flutter/material.dart';

class SampleTile extends StatelessWidget {
  const SampleTile(
    this.sample, {
    Key? key,
  }) : super(key: key);

  final Sample sample;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      title: Text(sample.plain),
      subtitle: sample.translation == null ? null : Text(sample.translation!),
    );
  }
}
