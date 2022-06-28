import 'package:auto_route/auto_route.dart';
import 'package:avzag/store.dart';

class RootGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final module = prefs.getString('module') ??
        (router.hasEntries ? 'dictionary' : 'home');
    router.popUntilRoot();
    router.pushNamed('/$module');
  }
}
