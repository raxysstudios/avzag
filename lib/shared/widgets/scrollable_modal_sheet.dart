import 'dart:ui';
import 'package:flutter/material.dart';

Future<T?> showScrollableModalSheet<T>({
  required BuildContext context,
  required ScrollableWidgetBuilder builder,
}) {
  final media = MediaQueryData.fromWindow(window);
  final size =
      1 - (kToolbarHeight + media.viewPadding.vertical) / media.size.height;
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        minChildSize: size - .1,
        initialChildSize: size,
        maxChildSize: size,
        builder: (context, controller) {
          return Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            color: Theme.of(context).scaffoldBackgroundColor,
            clipBehavior: Clip.antiAlias,
            child: builder(context, controller),
          );
        },
      );
    },
  );
}
