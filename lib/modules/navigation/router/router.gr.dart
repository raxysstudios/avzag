// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i6;
import 'package:flutter/material.dart' as _i7;

import '../../../initial_page.dart' as _i1;
import '../../dictionary/models/word.dart' as _i8;
import '../../dictionary/screens/dictionary.dart' as _i4;
import '../../dictionary/screens/word.dart' as _i5;
import '../../home/screens/home.dart' as _i2;
import '../account.dart' as _i3;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    InitialPageRoute.name: (routeData) {
      return _i6.MaterialPageX<_i6.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i1.InitialPage());
    },
    HomeScreenRoute.name: (routeData) {
      return _i6.MaterialPageX<_i6.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i2.HomeScreen());
    },
    AccountScreenRoute.name: (routeData) {
      return _i6.MaterialPageX<_i6.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i3.AccountScreen());
    },
    DictionaryScreenRoute.name: (routeData) {
      return _i6.MaterialPageX<_i6.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i4.DictionaryScreen());
    },
    WordScreenRoute.name: (routeData) {
      final args = routeData.argsAs<WordScreenRouteArgs>();
      return _i6.MaterialPageX<_i6.AutoRoute<dynamic>>(
          routeData: routeData,
          child: _i5.WordScreen(args.word,
              scroll: args.scroll,
              onEdit: args.onEdit,
              embedded: args.embedded,
              key: args.key));
    }
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(InitialPageRoute.name, path: '/', children: [
          _i6.RouteConfig(HomeScreenRoute.name,
              path: 'home', parent: InitialPageRoute.name),
          _i6.RouteConfig(AccountScreenRoute.name,
              path: 'account', parent: InitialPageRoute.name),
          _i6.RouteConfig(DictionaryScreenRoute.name,
              path: 'dictionary',
              parent: InitialPageRoute.name,
              children: [
                _i6.RouteConfig(WordScreenRoute.name,
                    path: ':id', parent: DictionaryScreenRoute.name)
              ])
        ])
      ];
}

/// generated route for
/// [_i1.InitialPage]
class InitialPageRoute extends _i6.PageRouteInfo<void> {
  const InitialPageRoute({List<_i6.PageRouteInfo>? children})
      : super(InitialPageRoute.name, path: '/', initialChildren: children);

  static const String name = 'InitialPageRoute';
}

/// generated route for
/// [_i2.HomeScreen]
class HomeScreenRoute extends _i6.PageRouteInfo<void> {
  const HomeScreenRoute() : super(HomeScreenRoute.name, path: 'home');

  static const String name = 'HomeScreenRoute';
}

/// generated route for
/// [_i3.AccountScreen]
class AccountScreenRoute extends _i6.PageRouteInfo<void> {
  const AccountScreenRoute() : super(AccountScreenRoute.name, path: 'account');

  static const String name = 'AccountScreenRoute';
}

/// generated route for
/// [_i4.DictionaryScreen]
class DictionaryScreenRoute extends _i6.PageRouteInfo<void> {
  const DictionaryScreenRoute({List<_i6.PageRouteInfo>? children})
      : super(DictionaryScreenRoute.name,
            path: 'dictionary', initialChildren: children);

  static const String name = 'DictionaryScreenRoute';
}

/// generated route for
/// [_i5.WordScreen]
class WordScreenRoute extends _i6.PageRouteInfo<WordScreenRouteArgs> {
  WordScreenRoute(
      {required _i8.Word word,
      _i7.ScrollController? scroll,
      void Function(_i8.Word)? onEdit,
      bool embedded = false,
      _i7.Key? key})
      : super(WordScreenRoute.name,
            path: ':id',
            args: WordScreenRouteArgs(
                word: word,
                scroll: scroll,
                onEdit: onEdit,
                embedded: embedded,
                key: key));

  static const String name = 'WordScreenRoute';
}

class WordScreenRouteArgs {
  const WordScreenRouteArgs(
      {required this.word,
      this.scroll,
      this.onEdit,
      this.embedded = false,
      this.key});

  final _i8.Word word;

  final _i7.ScrollController? scroll;

  final void Function(_i8.Word)? onEdit;

  final bool embedded;

  final _i7.Key? key;

  @override
  String toString() {
    return 'WordScreenRouteArgs{word: $word, scroll: $scroll, onEdit: $onEdit, embedded: $embedded, key: $key}';
  }
}