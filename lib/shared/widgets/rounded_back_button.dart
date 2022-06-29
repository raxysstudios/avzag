import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class RoundedBackButton extends StatelessWidget {
  const RoundedBackButton({
    this.icon = Icons.arrow_back_rounded,
    this.route,
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final PageRouteInfo? route;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (route == null) {
          Navigator.maybePop(context);
        } else {
          context.navigateTo(route!);
        }
      },
      tooltip: 'Back',
      icon: Icon(icon),
    );
  }
}
