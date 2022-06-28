import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router.gr.dart';

class _NavModule {
  const _NavModule(
    this.icon,
    this.text, [
    this.route,
  ]);

  final IconData icon;
  final String text;
  final PageRouteInfo? route;
}

const navModules = [
  _NavModule(
    Icons.home_rounded,
    'home',
    HomeRoute(),
  ),
  _NavModule(
    Icons.book_rounded,
    'dictionary',
    DictionaryRoute(),
  ),
  _NavModule(Icons.music_note_rounded, 'phonology'),
  _NavModule(Icons.switch_left_rounded, 'converter'),
  _NavModule(Icons.forum_rounded, 'phrasebook'),
  _NavModule(Icons.local_library_rounded, 'bootcamp'),
];
