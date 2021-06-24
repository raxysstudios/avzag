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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (letter != null)
              Text(
                letter!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            Text(
              phoneme,
              style: TextStyle(
                fontSize: letter == null ? 20 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
