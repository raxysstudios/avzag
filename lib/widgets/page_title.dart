import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PageTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: capitalize(title) + '\n',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null)
            TextSpan(
              text: '\n' + capitalize(subtitle!),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            )
        ],
      ),
    );
  }
}
