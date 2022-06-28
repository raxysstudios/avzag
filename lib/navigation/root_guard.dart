import 'package:auto_route/auto_route.dart';
import 'package:avzag/navigation/router.gr.dart';
import 'package:avzag/store.dart';

import 'nav_modules.dart';

class RootGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var route = router.hasEntries ? const DictionaryRoute() : const HomeRoute();
    final saved = prefs.getString('module');
    for (final m in navModules) {
      if (saved == m.text && m.route != null) {
        route = m.route!;
        break;
      }
    }
    router.pushAndPopUntil(route, predicate: (_) => true);
  }
}
