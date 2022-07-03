import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Route<T> dialogRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return DialogRoute(
    settings: page,
    context: context,
    barrierColor: Colors.transparent,
    builder: (context) => child,
  );
}

Route<T> sheetRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) {
  return ModalBottomSheetRoute(
    settings: page,
    expanded: true,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: kToolbarHeight),
          child: child,
        ),
      );
    },
  );
}
