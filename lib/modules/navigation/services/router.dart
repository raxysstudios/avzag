import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/account/screens/account.dart';
import 'package:avzag/modules/dictionary/screens/dictionary.dart';
import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/modules/dictionary/screens/word_editor.dart';
import 'package:avzag/modules/dictionary/screens/word_loader.dart';
import 'package:avzag/modules/dictionary/screens/words_diff.dart';
import 'package:avzag/modules/home/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'root_guard.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    AutoRoute<void>(
      path: '/',
      page: EmptyRouterScreen,
      name: 'RootRoute',
      guards: [RootGuard],
    ),
    AutoRoute<void>(
      path: '/account',
      page: AccountScreen,
    ),
    AutoRoute<void>(
      path: '/home',
      page: HomeScreen,
    ),
    AutoRoute<void>(
      path: '/dictionary',
      page: EmptyRouterScreen,
      name: 'DictionaryRoute',
      children: [
        AutoRoute<void>(
          path: '',
          page: DictionaryScreen,
          name: '_DictionaryRoute',
        ),
        CustomRoute<void>(
          path: ':id',
          page: WordLoaderScreen,
          customRouteBuilder: dialogRouteBuilder,
        ),
        CustomRoute<void>(
          path: ':id',
          page: WordScreen,
          customRouteBuilder: sheetRouteBuilder,
        ),
        CustomRoute<void>(
          path: 'editor',
          page: WordEditorScreen,
          customRouteBuilder: sheetRouteBuilder,
        ),
        CustomRoute<void>(
          path: 'diff',
          page: WordsDiffScreen,
          customRouteBuilder: sheetRouteBuilder,
        ),
      ],
    ),
    RedirectRoute(path: '*', redirectTo: '/')
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
    barrierColor: Colors.transparent,
  );
}

Route<T> sheetRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return ModalBottomSheetRoute(
    settings: page,
    builder: (context) => child,
    expanded: true,
  );
}
