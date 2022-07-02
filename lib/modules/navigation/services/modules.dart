import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'router.gr.dart';

class NavModule {
  const NavModule(
    this.icon,
    this.text, [
    this.route,
  ]);

  final IconData icon;
  final String text;
  final PageRouteInfo? route;
}

const modules = [
  NavModule(
    Icons.home_rounded,
    'home',
    HomeRoute(),
  ),
  NavModule(
    Icons.book_rounded,
    'dictionary',
    DictionaryRoute(),
  ),
  NavModule(Icons.music_note_rounded, 'phonology'),
  NavModule(Icons.switch_left_rounded, 'converter'),
  NavModule(Icons.forum_rounded, 'phrasebook'),
  NavModule(Icons.local_library_rounded, 'bootcamp'),
];
