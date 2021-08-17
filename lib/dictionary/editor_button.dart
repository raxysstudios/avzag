import 'package:avzag/dictionary/entry.dart';
import 'package:avzag/dictionary/hit_tile.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditorButton extends StatelessWidget {
  final Entry? entry;
  final EntryHit? hit;
  final bool editing;
  final bool collapsed;
  final void Function(Entry entry, EntryHit hit) onStart;
  final VoidCallback onEnd;

  const EditorButton(
    this.entry,
    this.hit, {
    this.editing = false,
    this.collapsed = false,
    required this.onStart,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (collapsed) {
      if (editing)
        return FloatingActionButton.extended(
          onPressed: () async {
            if (await showDangerDialog(
              context,
              'Discard edits?',
              confirmText: 'Discard',
              rejectText: 'Edit',
            )) onEnd();
          },
          icon: Icon(Icons.close_outlined),
          label: Text('Discard'),
          backgroundColor: Colors.redAccent,
        );
      return FloatingActionButton.extended(
        onPressed: () => onStart(
          Entry(forms: [], uses: []),
          EntryHit(
            entryID: '',
            headword: '',
            language: EditorStore.language!,
            term: '',
          ),
        ),
        icon: Icon(Icons.add_outlined),
        label: Text('New'),
      );
    }
    if (editing)
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: kFloatingActionButtonMargin * 2),
              child: FloatingActionButton(
                onPressed: () async {
                  if (await delete(context)) onEnd();
                },
                child: Icon(Icons.delete_outlined),
                tooltip: 'Delete',
                backgroundColor: Colors.redAccent,
                mini: true,
              ),
            ),
            FloatingActionButton.extended(
              onPressed: () async {
                if (await submit(context)) onEnd();
              },
              icon: Icon(Icons.publish_outlined),
              label: Text('Submit'),
            ),
          ],
        ),
      );
    return FloatingActionButton.extended(
      onPressed: () => onStart(entry!, hit!),
      icon: Icon(Icons.edit_outlined),
      label: Text('Edit'),
    );
  }

  Future<bool> submit(BuildContext context) async {
    if (entry == null || hit == null) return false;
    if (entry!.uses.isEmpty || entry!.forms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Must have at least one form and one use.',
              ),
            ],
          ),
        ),
      );
      return false;
    }
    final collection = FirebaseFirestore.instance
        .collection('languages/${EditorStore.language}/dictionary');
    final json = entry!.toJson();
    final upload = hit!.entryID.isEmpty
        ? collection.add(json)
        : collection.doc(hit!.entryID).update(json);
    await showLoadingDialog(context, upload);
    Navigator.pop(context);
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    if (entry == null || hit == null) return false;
    if (entry!.uses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: Colors.white,
              ),
              SizedBox(width: 8),
              Text(
                'Must have at least one form and one use.',
              ),
            ],
          ),
        ),
      );
      return false;
    }
    final confirm = await showDangerDialog(
      context,
      'Delete entry?',
      confirmText: 'Delete',
      rejectText: 'Keep',
    );
    if (confirm) {
      await showLoadingDialog(
        context,
        FirebaseFirestore.instance
            .collection('languages/${EditorStore.language}/dictionary')
            .doc(hit!.entryID)
            .delete(),
      );
      Navigator.pop(context);
      return true;
    }
    return false;
  }
}
