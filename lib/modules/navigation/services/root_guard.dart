import 'package:auto_route/auto_route.dart';
import 'package:avzag/store.dart';

import 'modules.dart';
import 'router.gr.dart';

class RootGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var route =
        router.hasEntries ? const DictionaryRootRoute() : const HomeRoute();
    final saved = prefs.getString('module');
    for (final m in modules) {
      if (saved == m.text && m.route != null) {
        route = m.route!;
        break;
      }
    }
    if (saved == null && router.hasEntries) {
      prefs.setString('module', 'dictionary');
    }
    router.pushAndPopUntil(route, predicate: (_) => true);
  }
}
