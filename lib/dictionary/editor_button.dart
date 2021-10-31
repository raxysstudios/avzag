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
    Key? key,
    this.hit,
    this.editing = false,
    this.collapsed = false,
    required this.onStart,
    required this.onEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (GlobalStore.editing == null ||
        (hit != null && GlobalStore.editing != hit!.language)) {
      return const SizedBox();
    }

    final dangerColor = Theme.of(context).colorScheme.error;
    if (collapsed) {
      if (editing) {
        return FloatingActionButton.extended(
          onPressed: () async {
            if (await showDangerDialog(
              context,
              'Discard edits?',
              confirmText: 'Discard',
              rejectText: 'Edit',
            )) onEnd();
          },
          icon: const Icon(Icons.close_outlined),
          label: const Text('Discard'),
          backgroundColor: dangerColor,
        );
      }
      return FloatingActionButton.extended(
        onPressed: () => onStart(Entry(forms: [], uses: [])),
        icon: const Icon(Icons.add_outlined),
        label: const Text('New'),
      );
    }
    if (editing) {
      return SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (hit == null)
              const SizedBox()
            else
              Padding(
                padding: const EdgeInsets.only(
                  left: kFloatingActionButtonMargin * 1.75,
                ),
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await delete(context)) onEnd();
                  },
                  child: const Icon(Icons.delete_outlined),
                  tooltip: 'Delete',
                  backgroundColor: dangerColor,
                  mini: true,
                ),
              ),
            FloatingActionButton.extended(
              onPressed: () async {
                if (await submit(context)) onEnd();
              },
              icon: const Icon(Icons.publish_outlined),
              label: const Text('Submit'),
            ),
          ],
        ),
      );
    }
    return FloatingActionButton.extended(
      onPressed: () => onStart(entry!, hit),
      icon: const Icon(Icons.edit_outlined),
      label: const Text('Edit'),
    );
  }

  Future<bool> submit(BuildContext context) async {
    if (entry == null) return false;
    if (entry!.uses.isEmpty || entry!.forms.isEmpty) {
      showSnackbar(
        context,
        text: 'Must have at least a form and a use.',
      );
      return false;
    }
    await showLoadingDialog(
      context,
      FirebaseFirestore.instance
          .doc('dictionary/${hit?.entryID}')
          .set(entry!.toJson()),
    );
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    if (entry == null || hit == null) return false;
    if (entry!.uses.isNotEmpty) {
      showSnackbar(
        context,
        text: 'Remove all uses first.',
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
        FirebaseFirestore.instance.doc('dictionary/${hit!.entryID}').delete(),
      );
      return true;
    }
    return false;
  }
}
