import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/dictionary.dart';
import 'package:avzag/modules/dictionary/word.dart';
import 'package:avzag/modules/dictionary/word_editor.dart';
import 'package:avzag/modules/dictionary/word_loader.dart';
import 'package:avzag/modules/dictionary/words_diff.dart';
import 'package:avzag/modules/home/home.dart';
import 'package:avzag/modules/settings/settings.dart';

import 'root_guard.dart';
import 'route_builders.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Screen,Route',
  routes: [
    AutoRoute<void>(
      path: '/',
      page: EmptyRouterScreen,
      name: 'RootRoute',
      guards: [RootGuard],
      children: [
        AutoRoute<void>(
          path: '',
          page: DictionaryScreen,
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
      ],
    ),
    AutoRoute<void>(
      path: '/home',
      page: HomeScreen,
    ),
    AutoRoute<void>(
      path: '/settings',
      page: SettingsScreen,
    ),
    RedirectRoute(path: '*', redirectTo: '/'),
  ],
)
class $AppRouter {}
