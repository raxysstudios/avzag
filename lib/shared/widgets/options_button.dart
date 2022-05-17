import 'package:flutter/material.dart';

class OptionItem {
  late final Widget? widget;
  final VoidCallback? onTap;

  OptionItem(
    this.widget, [
    this.onTap,
  ]);

  OptionItem.simple(
    IconData icon,
    String text, [
    this.onTap,
  ]) : widget = Row(
          children: [
            const SizedBox(width: 16),
            Icon(icon),
            const SizedBox(width: 16),
            Text(text),
            const SizedBox(width: 16),
          ],
        );

  OptionItem.divider()
      : widget = null,
        onTap = null;
}

class OptionsButton extends StatelessWidget {
  const OptionsButton(
    this.options, {
    this.icon = const Icon(Icons.more_vert_outlined),
    this.elevated = false,
    Key? key,
  }) : super(key: key);

  final bool elevated;
  final Widget icon;
  final List<OptionItem> options;

  PopupMenuEntry<int> _getMenuEntry(int i) {
    final w = options[i].widget;
    if (w == null) return const PopupMenuDivider();
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      value: i,
      child: w,
    );
  }

  Widget _applyStyle(BuildContext context, Widget child) {
    if (elevated) {
      final theme = Theme.of(context).colorScheme;
      return Card(
        color: theme.primary,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(64),
        ),
        child: child,
      );
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return _applyStyle(
      context,
      ListTileTheme(
        data: const ListTileThemeData(horizontalTitleGap: 0),
        child: PopupMenuButton<int>(
          icon: icon,
          onSelected: (i) => options[i].onTap?.call(),
          itemBuilder: (context) {
            return [
              for (var i = 0; i < options.length; i++) _getMenuEntry(i),
            ];
          },
        ),
      ),
    );
  }
}
