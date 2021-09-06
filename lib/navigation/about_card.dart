import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutCard extends StatefulWidget {
  @override
  _AboutCardState createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  PackageInfo? package;

  @override
  initState() {
    super.initState();
    PackageInfo.fromPlatform().then(
      (value) => setState(() {
        package = value;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.landscape_outlined),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      height: 1.5,
                    ),
                children: [
                  TextSpan(text: 'Made with honor in '),
                  TextSpan(
                    text: 'North Caucasus',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '.'),
                  if (package != null)
                    TextSpan(
                      text: '\nv${package!.version} • b${package!.buildNumber}',
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
