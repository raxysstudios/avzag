import 'package:auto_route/auto_route.dart';
import 'package:avzag/initial_page.dart';
import 'package:avzag/modules/dictionary/screens/dictionary.dart';
import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/modules/home/screens/home.dart';
import 'package:avzag/modules/navigation/account.dart';
import 'package:avzag/modules/navigation/router/router.gr.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute<AutoRoute>(
      path: '/',
      page: EmptyRouterPage,
      children: [
        AutoRoute<AutoRoute>(
          path: '',
          page: InitialPage,
        ),
        AutoRoute<AutoRoute>(
          path: 'home',
          page: HomeScreen,
        ),
        AutoRoute<AutoRoute>(
          path: 'account',
          page: AccountScreen,
        ),
        AutoRoute<AutoRoute>(
          path: 'dictionary',
          name: 'DictRouter',
          page: EmptyRouterPage,
          children: [
            AutoRoute<AutoRoute>(
              path: '',
              page: DictionaryScreen,
              children: [
                AutoRoute<AutoRoute>(
                  path: ':id',
                  page: WordScreen,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}
