import 'package:flutter/material.dart';

class RoundedDrawerButton extends StatelessWidget {
  const RoundedDrawerButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: Scaffold.of(context).openDrawer,
      tooltip: 'Menu',
      icon: const Icon(Icons.menu_rounded),
    );
  }
}
