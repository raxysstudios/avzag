import 'package:flutter/material.dart';

import '../note_list.dart';
import '../utils.dart';
import 'models.dart';

class EntryCard extends StatefulWidget {
  final Entry entry;
  final bool scholar;

  EntryCard(this.entry, {this.scholar = false});

  @override
  _EntryCardState createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool expanded = false;

  String get defaultForm => widget.entry.forms[0].plain;
  bool get scholar => widget.scholar;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> buildUse(Use use) {
    return [
      Row(
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: [
          Text(
            capitalize(use.meaning),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (scholar && use.tags != null)
            for (final t in use.tags!) ...[
              VerticalDivider(width: 8),
              Text(
                t,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ],
        ],
      ),
      if (use.notes != null) ...[
        Divider(
          height: 4,
          color: Colors.transparent,
        ),
        NoteList(use.notes),
      ],
      if (use.samples != null)
        for (final s in use.samples!) ...[
          Divider(
            height: 4,
            color: Colors.transparent,
          ),
          Text(
            s.plain,
            style: TextStyle(fontSize: 16),
          ),
          if (s.translation != null)
            Text(
              s.translation!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          if (scholar && s.ipa != null)
            Text(
              s.ipa!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          if (scholar && s.glossed != null)
            Text(
              s.glossed!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
        ],
    ];
  }

  List<Widget> buildForms() {
    return [
      if (scholar && widget.entry.tags != null) ...[
        Row(
          children: [
            for (final t in widget.entry.tags!) ...[
              Text(
                t,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
              VerticalDivider(width: 8),
            ],
          ],
        ),
        Divider(
          height: 4,
          color: Colors.transparent,
        ),
      ],
      for (final f in widget.entry.forms)
        Row(
          children: [
            Text(
              f.plain,
              style: TextStyle(fontSize: 16),
            ),
            VerticalDivider(width: 8),
            if (scholar && f.ipa != null)
              Text(
                f.ipa!,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            VerticalDivider(width: 8),
            if (scholar && f.glossed != null)
              Text(
                f.glossed!,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.only(left: 8),
          title: Text(
            expanded ? capitalize(defaultForm) : defaultForm,
            style: TextStyle(
              fontSize: 20,
              fontWeight: expanded ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          onTap: () => setState(() => expanded = !expanded),
          dense: true,
          trailing: expanded
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: [
                    Tab(icon: const Icon(Icons.textsms_outlined)),
                    Tab(icon: const Icon(Icons.info_outlined)),
                  ],
                )
              : null,
        ),
        if (expanded) ...[
          Container(
            height: 256,
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: widget.entry.uses == null
                      ? Text("No uses data.")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final u in widget.entry.uses!) ...[
                              ...buildUse(u),
                              Divider(
                                height: 4,
                                color: Colors.transparent,
                              ),
                            ],
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: buildForms(),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0)
        ],
      ],
    );
  }
}
