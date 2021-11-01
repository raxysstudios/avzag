import 'package:avzag/widgets/loading_card.dart';
import 'package:avzag/widgets/snackbar_manager.dart';
import 'package:flutter/material.dart';

Future<T?> showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const LoadingCard(),
  );
  try {
    final result = await future;
    Navigator.pop(context);
    return result;
  } catch (e) {
    Navigator.pop(context);
    showSnackbar(context);
  }
  return null;
}
