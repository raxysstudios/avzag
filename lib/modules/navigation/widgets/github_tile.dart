import 'package:avzag/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GitHubTile extends StatefulWidget {
  const GitHubTile({Key? key}) : super(key: key);

  @override
  State<GitHubTile> createState() => _GitHubTileState();
}

class _GitHubTileState extends State<GitHubTile> {
  var info = 'Loading...';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then(
      (package) => setState(() {
        info = 'v${package.version} • b${package.buildNumber}';
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.code_outlined),
      title: const Text('GitHub Repository'),
      subtitle: Text(info),
      onTap: () => openLink(
        'https://github.com/raxysstudios/avzag',
      ),
    );
  }
}
