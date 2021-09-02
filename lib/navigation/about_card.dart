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
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  if (package != null)
                    TextSpan(
                      text: 'v${package!.version} • b${package!.buildNumber}\n',
                    ),
                  TextSpan(text: 'Built with '),
                  TextSpan(
                    text: 'Flutter ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  WidgetSpan(
                    child: FlutterLogo(size: 16),
                  ),
                  TextSpan(text: ' & '),
                  TextSpan(
                    text: 'Firebase ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'firebase.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  TextSpan(text: '.\nSearch powered by '),
                  TextSpan(
                    text: 'Algolia ',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  WidgetSpan(
                    child: Image.asset(
                      'algolia.png',
                      width: 16,
                      height: 16,
                    ),
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
