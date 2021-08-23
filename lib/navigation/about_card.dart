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
                Icon(
                  Icons.landscape_outlined,
                  color: Colors.black54,
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(text: 'Made with honor in '),
                      TextSpan(
                        text: 'North Caucasus',
                        style: Theme.of(context).textTheme.bodyText1,
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
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      TextSpan(
                        text:
                            'v${package!.version} • b${package!.buildNumber}\n',
                      ),
                      TextSpan(text: 'Build with '),
                      TextSpan(
                        text: 'Flutter SDK',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(text: ' & '),
                      TextSpan(
                        text: 'Firebase',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(text: '.\nSearch powered by '),
                      TextSpan(
                        text: 'Algolia',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextSpan(text: '.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () => launch('https://flutter.dev/'),
                      icon: FlutterLogo(size: 24),
                    ),
                    IconButton(
                      onPressed: () => launch('https://firebase.google.com/'),
                      icon: Image.asset(
                        'firebase.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: () => launch('https://www.algolia.com/'),
                      icon: Image.asset(
                        'algolia.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
