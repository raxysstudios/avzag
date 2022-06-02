import 'package:auto_route/auto_route.dart';
import 'package:avzag/initial_page.dart';
import 'package:avzag/modules/dictionary/screens/dictionary.dart';
import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/modules/home/screens/home.dart';
import 'package:avzag/modules/navigation/account.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute<AutoRoute>(
      path: '/',
      page: EmptyRouterScreen,
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
          page: DictionaryScreen,
        ),
        AutoRoute<AutoRoute>(
          path: 'dictionary/:id',
          page: WordScreen,
        ),
      ],
    ),
  ],
)
class $AppRouter {}
