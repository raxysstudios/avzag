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
    Icons.home_outlined,
    'home',
    HomeRoute(),
  ),
  NavModule(
    Icons.book_outlined,
    'dictionary',
    DictionaryRootRoute(),
  ),
  NavModule(Icons.music_note_outlined, 'phonology'),
  NavModule(Icons.switch_left_outlined, 'converter'),
  NavModule(Icons.forum_outlined, 'phrasebook'),
  NavModule(Icons.local_library_outlined, 'bootcamp'),
];
