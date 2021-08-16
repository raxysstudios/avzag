import 'package:flutter/material.dart';

Future<T?> showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    },
  );
  try {
    final result = await future;
    Navigator.pop(context);
    return result;
  } catch (e) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outlined,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'Error!',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
