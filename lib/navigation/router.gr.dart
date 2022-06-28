// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i1;
import 'package:flutter/material.dart' as _i5;

import '../modules/dictionary/screens/dictionary.dart' as _i4;
import '../modules/home/screens/home.dart' as _i2;
import '../modules/navigation/account.dart' as _i3;
import 'root_guard.dart' as _i6;

class AppRouter extends _i1.RootStackRouter {
  AppRouter(
      {_i5.GlobalKey<_i5.NavigatorState>? navigatorKey,
      required this.rootGuard})
      : super(navigatorKey);

  final _i6.RootGuard rootGuard;

  @override
  final Map<String, _i1.PageFactory> pagesMap = {
    RootRoute.name: (routeData) {
      return _i1.MaterialPageX<void>(
          routeData: routeData, child: const _i1.EmptyRouterScreen());
    },
    HomeRoute.name: (routeData) {
      return _i1.MaterialPageX<void>(
          routeData: routeData, child: const _i2.HomeScreen());
    },
    AccountRoute.name: (routeData) {
      return _i1.MaterialPageX<void>(
          routeData: routeData, child: const _i3.AccountScreen());
    },
    EmptyRouterRoute.name: (routeData) {
      return _i1.MaterialPageX<void>(
          routeData: routeData, child: const _i1.EmptyRouterScreen());
    },
    DictionaryRoute.name: (routeData) {
      return _i1.MaterialPageX<void>(
          routeData: routeData, child: const _i4.DictionaryScreen());
    }
  };

  @override
  List<_i1.RouteConfig> get routes => [
        _i1.RouteConfig(RootRoute.name, path: '/', guards: [rootGuard]),
        _i1.RouteConfig(HomeRoute.name, path: '/home'),
        _i1.RouteConfig(AccountRoute.name, path: '/account'),
        _i1.RouteConfig(EmptyRouterRoute.name, path: '/dictionary', children: [
          _i1.RouteConfig(DictionaryRoute.name,
              path: '', parent: EmptyRouterRoute.name)
        ]),
        _i1.RouteConfig('*#redirect',
            path: '*', redirectTo: '/', fullMatch: true)
      ];
}

/// generated route for
/// [_i1.EmptyRouterScreen]
class RootRoute extends _i1.PageRouteInfo<void> {
  const RootRoute() : super(RootRoute.name, path: '/');

  static const String name = 'RootRoute';
}

/// generated route for
/// [_i2.HomeScreen]
class HomeRoute extends _i1.PageRouteInfo<void> {
  const HomeRoute() : super(HomeRoute.name, path: '/home');

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i3.AccountScreen]
class AccountRoute extends _i1.PageRouteInfo<void> {
  const AccountRoute() : super(AccountRoute.name, path: '/account');

  static const String name = 'AccountRoute';
}

/// generated route for
/// [_i1.EmptyRouterScreen]
class EmptyRouterRoute extends _i1.PageRouteInfo<void> {
  const EmptyRouterRoute({List<_i1.PageRouteInfo>? children})
      : super(EmptyRouterRoute.name,
            path: '/dictionary', initialChildren: children);

  static const String name = 'EmptyRouterRoute';
}

/// generated route for
/// [_i4.DictionaryScreen]
class DictionaryRoute extends _i1.PageRouteInfo<void> {
  const DictionaryRoute() : super(DictionaryRoute.name, path: '');

  static const String name = 'DictionaryRoute';
}
