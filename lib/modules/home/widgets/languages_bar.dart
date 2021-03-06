import 'package:bazur/models/language.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/language_avatar.dart';
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
        duration: duration200,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: widget.languages.isEmpty ? 0 : kBottomNavigationBarHeight,
      duration: duration200,
      child: BottomAppBar(
        child: ListView(
          controller: scroll,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          children: [
            IconButton(
              onPressed: widget.onClear,
              icon: const Icon(Icons.cancel_outlined),
            ),
            const SizedBox(width: 18),
            for (final language in widget.languages)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: InputChip(
                  avatar: LanguageAvatar(
                    language.name,
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
