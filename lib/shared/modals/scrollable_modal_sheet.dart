import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showScrollableModalSheet<T>(
  BuildContext context,
  Widget Function(BuildContext) builder,
) {
  return context.router.pushNativeRoute<T>(
    ModalBottomSheetRoute(
      builder: builder,
      expanded: true,
    ),
  );
}
