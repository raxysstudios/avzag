import 'package:flutter/material.dart';

class PhonemeButton extends StatelessWidget {
  final String phoneme;
  final String? letter;
  final Function()? onTap;

  const PhonemeButton(
    this.phoneme, {
    this.letter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (letter != null) Text(letter!),
            Text(phoneme),
          ],
        ),
      ),
    );
  }
}
