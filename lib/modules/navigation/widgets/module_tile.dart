import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/navigation/services/modules.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

import '../services/router.gr.dart';

class ModuleTile extends StatelessWidget {
  const ModuleTile(
    this.module, {
    Key? key,
  }) : super(key: key);

  final NavModule module;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(module.icon),
      title: Text(
        module.text.titled,
        style: const TextStyle(fontSize: 18),
      ),
      trailing:
          module.route == null ? const Icon(Icons.construction_rounded) : null,
      selected: context.router.currentPath.startsWith(module.route?.path ?? ''),
      onTap: () async {
        if (module.route != const HomeRoute()) {
          await prefs.setString('module', module.text);
        }
        context.pushRoute(module.route!);
      },
      enabled: module.route != null,
    );
  }
}
