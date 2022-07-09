import 'package:auto_route/auto_route.dart';
import 'package:avzag/store.dart';

import 'router.gr.dart';

class RootGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    if (prefs.getStringList('languages')?.isNotEmpty ?? false) {
      resolver.next();
    } else {
      router.replaceAll([const HomeRoute()]);
    }
  }
}
