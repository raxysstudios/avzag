import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(Icons.landscape_outlined),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(text: 'Made with honor in '),
                      TextSpan(
                        text: 'North Caucasus',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2?.copyWith(
                      height: 1.5,
                    ),
                children: [
                  if (package != null)
                    TextSpan(
                      text: 'v${package!.version} • b${package!.buildNumber}\n',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  TextSpan(text: 'Built with '),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: FlutterLogo(size: 16),
                    ),
                  ),
                  TextSpan(
                    text: 'Flutter',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: ' & '),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Image.asset(
                        'firebase.png',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Firebase',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(text: '.\nSearch powered by '),
                  WidgetSpan(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2),
                      child: Image.asset(
                        'algolia.png',
                        width: 16,
                        height: 16,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: 'Algolia',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  TextSpan(text: '.'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
