// class IPARegistry {
//   static  Map<String, String> _primary = {};
//   static  Map<String, String> _secondary = {};

//   static load(Map<String, dynamic> json) {
//     _primary = json['primary'];
//     _secondary = json['secondary'];
//   }

//   function collectTags(phomene: string) {
//   let collected = "";
//   for (const { ipa, tags } of registry.primary) {
//     if (phomene.includes(ipa)) {
//       collected += tags;
//       break;
//     }
//   }
//   for (const { ipa, tags } of registry.secondary) {
//     if (phomene.includes(ipa)) {
//       collected += " " + tags;
//     }
//   }
//   return collected;
// }

// function collectPhonemes(allUses: Record<string, PhonemeUse[]>) {
//   const registry = {} as Record<string, Phoneme>;

//   for (const name in allUses) {
//     const uses = allUses[name];
//     if (!uses) continue;

//     uses.forEach((use) => {
//       const phoneme = use.phoneme;
//       if (!(phoneme in registry)) {
//         registry[phoneme] = {
//           ipa: phoneme,
//           tags: collectTags(phoneme),
//           lects: {},
//         };
//       }
//       registry[phoneme].lects[name] = use;
//     });
//   }

//   phonemes.value = Object.values(registry);
//   phonemes.value.sort(({ ipa: a }, { ipa: b }) => (a > b ? 1 : b > a ? -1 : 0));
//   phoneme.value = phonemes.value[0];
// }
// }
