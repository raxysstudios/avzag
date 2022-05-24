// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../../dictionary/models/word.dart' as _i7;
import '../../dictionary/screens/dictionary.dart' as _i3;
import '../../dictionary/screens/word.dart' as _i4;
import '../../home/screens/home.dart' as _i1;
import '../account.dart' as _i2;

class AppRouter extends _i5.RootStackRouter {
  AppRouter([_i6.GlobalKey<_i6.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    HomeScreen.name: (routeData) {
      return _i5.MaterialPageX<_i5.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i1.HomeScreen());
    },
    AccountScreen.name: (routeData) {
      return _i5.MaterialPageX<_i5.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i2.AccountScreen());
    },
    DictionaryScreen.name: (routeData) {
      return _i5.MaterialPageX<_i5.AutoRoute<dynamic>>(
          routeData: routeData, child: const _i3.DictionaryScreen());
    },
    WordScreen.name: (routeData) {
      final args = routeData.argsAs<WordScreenArgs>();
      return _i5.MaterialPageX<_i5.AutoRoute<dynamic>>(
          routeData: routeData,
          child: _i4.WordScreen(args.word,
              scroll: args.scroll,
              onEdit: args.onEdit,
              embedded: args.embedded,
              key: args.key));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(HomeScreen.name, path: '/', children: [
          _i5.RouteConfig(AccountScreen.name,
              path: 'account', parent: HomeScreen.name),
          _i5.RouteConfig(DictionaryScreen.name,
              path: 'dictionary',
              parent: HomeScreen.name,
              children: [
                _i5.RouteConfig(WordScreen.name,
                    path: ':id', parent: DictionaryScreen.name)
              ])
        ])
      ];
}

/// generated route for
/// [_i1.HomeScreen]
class HomeScreen extends _i5.PageRouteInfo<void> {
  const HomeScreen({List<_i5.PageRouteInfo>? children})
      : super(HomeScreen.name, path: '/', initialChildren: children);

  static const String name = 'HomeScreen';
}

/// generated route for
/// [_i2.AccountScreen]
class AccountScreen extends _i5.PageRouteInfo<void> {
  const AccountScreen() : super(AccountScreen.name, path: 'account');

  static const String name = 'AccountScreen';
}

/// generated route for
/// [_i3.DictionaryScreen]
class DictionaryScreen extends _i5.PageRouteInfo<void> {
  const DictionaryScreen({List<_i5.PageRouteInfo>? children})
      : super(DictionaryScreen.name,
            path: 'dictionary', initialChildren: children);

  static const String name = 'DictionaryScreen';
}

/// generated route for
/// [_i4.WordScreen]
class WordScreen extends _i5.PageRouteInfo<WordScreenArgs> {
  WordScreen(
      {required _i7.Word word,
      _i6.ScrollController? scroll,
      void Function(_i7.Word)? onEdit,
      bool embedded = false,
      _i6.Key? key})
      : super(WordScreen.name,
            path: ':id',
            args: WordScreenArgs(
                word: word,
                scroll: scroll,
                onEdit: onEdit,
                embedded: embedded,
                key: key));

  static const String name = 'WordScreen';
}

class WordScreenArgs {
  const WordScreenArgs(
      {required this.word,
      this.scroll,
      this.onEdit,
      this.embedded = false,
      this.key});

  final _i7.Word word;

  final _i6.ScrollController? scroll;

  final void Function(_i7.Word)? onEdit;

  final bool embedded;

  final _i6.Key? key;

  @override
  String toString() {
    return 'WordScreenArgs{word: $word, scroll: $scroll, onEdit: $onEdit, embedded: $embedded, key: $key}';
  }
}
