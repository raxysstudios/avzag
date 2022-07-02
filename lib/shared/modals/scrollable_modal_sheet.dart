import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showScrollableModalSheet<T>(
  BuildContext context,
  Widget Function(BuildContext, ScrollController?) builder,
) {
  // final media = MediaQueryData.fromWindow(window);
  // final size =
  //     1 - (kToolbarHeight + media.viewPadding.vertical) / media.size.height;
  return context.router.pushNativeRoute<T>(
    ModalBottomSheetRoute(
      builder: (context) => builder(
        context,
        ModalScrollController.of(context),
      ),
      expanded: true,
    ),
  );
}
