import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/screens/dictionary.dart';
import 'package:avzag/modules/home/screens/home.dart';
import 'package:avzag/modules/navigation/account.dart';
import 'package:flutter/material.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    AutoRoute<void>(
      path: '/',
      page: HomeScreen,
    ),
    AutoRoute<void>(
      path: '/account',
      page: AccountScreen,
    ),
    AutoRoute<void>(
      path: '/dictionary',
      page: EmptyRouterScreen,
      children: [
        AutoRoute<void>(
          path: '',
          page: DictionaryScreen,
        )
      ],
    )
  ],
)
class $AppRouter {}

Route<T> dialogRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return DialogRoute(
    settings: page,
    context: context,
    builder: (context) => child,
  );
}
