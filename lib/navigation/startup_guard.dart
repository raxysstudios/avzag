import 'package:auto_route/auto_route.dart';
import 'package:avzag/store.dart';

class StartupGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final url = prefs.getString('module') ?? 'home';
    router.replaceNamed('/$url');
  }
}
