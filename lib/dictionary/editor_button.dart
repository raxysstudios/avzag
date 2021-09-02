import 'package:avzag/dictionary/entry.dart';
import 'package:avzag/dictionary/hit_tile.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/snackbar_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditorButton extends StatelessWidget {
  final Entry? entry;
  final EntryHit? hit;
  final bool editing;
  final bool collapsed;
  final void Function(Entry entry, [EntryHit? hit]) onStart;
  final VoidCallback onEnd;

  const EditorButton(
    this.entry, {
    this.hit,
    this.editing = false,
    this.collapsed = false,
    required this.onStart,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    if (GlobalStore.editing == null ||
        (hit != null && GlobalStore.editing != hit!.language))
      return SizedBox();

    final background = Theme.of(context).colorScheme.primary;
    final danger = Theme.of(context).colorScheme.error;
    final foreground = Theme.of(context).colorScheme.onPrimary;

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
          backgroundColor: danger,
          foregroundColor: foreground,
        );
      return FloatingActionButton.extended(
        onPressed: () => onStart(Entry(forms: [], uses: [])),
        icon: Icon(Icons.add_outlined),
        label: Text('New'),
        backgroundColor: background,
        foregroundColor: foreground,
      );
    }
    if (editing)
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hit == null)
              SizedBox()
            else
              Padding(
                padding: const EdgeInsets.only(
                  left: kFloatingActionButtonMargin * 1.75,
                ),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await delete(context)) onEnd();
                  },
                  child: Icon(Icons.delete_outlined),
                  tooltip: 'Delete',
                  backgroundColor: danger,
                  foregroundColor: foreground,
                  mini: true,
                ),
              ),
            FloatingActionButton.extended(
              onPressed: () async {
                if (await submit(context)) onEnd();
              },
              icon: Icon(Icons.publish_outlined),
              label: Text('Submit'),
              backgroundColor: background,
              foregroundColor: foreground,
            ),
          ],
        ),
      );
    return FloatingActionButton.extended(
      onPressed: () => onStart(entry!, hit),
      icon: Icon(Icons.edit_outlined),
      label: Text('Edit'),
      backgroundColor: background,
      foregroundColor: foreground,
    );
  }

  Future<bool> submit(BuildContext context) async {
    if (entry == null) return false;
    if (entry!.uses.isEmpty || entry!.forms.isEmpty) {
      showSnackbar(context, 'Must have at least a form and a use.');
      return false;
    }
    await showLoadingDialog(
      context,
      FirebaseFirestore.instance
          .collection('languages/${GlobalStore.editing}/dictionary')
          .doc(hit?.entryID)
          .set(entry!.toJson()),
    );
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    if (entry == null || hit == null) return false;
    if (entry!.uses.isNotEmpty) {
      showSnackbar(context, 'Remove all uses first.');
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
            .collection('languages/${GlobalStore.editing}/dictionary')
            .doc(hit!.entryID)
            .delete(),
      );
      return true;
    }
    return false;
  }
}
