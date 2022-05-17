// import 'package:avzag/dictionary/models/sample.dart';
// import 'package:flutter/material.dart';

// class SamplesEditor extends StatelessWidget {
//   const SamplesEditor({Key? key}) : super(key: key);

//   final List<TextSample> samples;
//   final ValueSetter<String> onAdd;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         for (final s in samples)
//           ListTile(
//             leading: const Icon(Icons.tag_rounded),
//             title: TextFormField(
//               initialValue: s.plain,
//               onChanged: (s) => use.tags = s.trim().split(' '),
//             ),
//           ),
//         ListTile(),
//         const Divider(),
//       ],
//     );
//   }
// }
