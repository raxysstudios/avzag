import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LanguagesBar extends StatefulWidget {
  const LanguagesBar(
    this.languages, {
    required this.onTap,
    required this.onClear,
    Key? key,
  }) : super(key: key);

  final Iterable<Language> languages;
  final ValueSetter<Language> onTap;
  final VoidCallback onClear;

  @override
  State<LanguagesBar> createState() => _LanguagesBarState();
}

class _LanguagesBarState extends State<LanguagesBar> {
  final scroll = ScrollController();

  @override
  void didUpdateWidget(covariant LanguagesBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => scroll.animateTo(
        scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: SizedBox(
        height: kBottomNavigationBarHeight,
        child: ListView(
          controller: scroll,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          children: [
            IconButton(
              onPressed: widget.onClear,
              icon: const Icon(Icons.cancel_outlined),
              tooltip: 'Unselect all',
            ),
            const SizedBox(width: 18),
            for (final language in widget.languages)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: InputChip(
                  avatar: LanguageAvatar(
                    null,
                    url: language.flag,
                    radius: 12,
                  ),
                  label: Text(
                    language.name.titled,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => widget.onTap(language),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
