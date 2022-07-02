import 'package:avzag/shared/utils.dart';
import 'package:flutter/material.dart';

class StoresButtons extends StatelessWidget {
  const StoresButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.get_app_rounded),
      title: Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => openLink(
                'https://play.google.com/store/apps/details?id=com.alkaitagi.avzag',
              ),
              child: const Text('Google Play'),
            ),
          ),
          Expanded(
            child: TextButton(
              onPressed: () => openLink(
                'https://apps.apple.com/app/avzag-languages-of-caucasus/id1603226004',
              ),
              child: const Text('App Store'),
            ),
          ),
        ],
      ),
    );
  }
}
