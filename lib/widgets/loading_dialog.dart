import 'package:avzag/widgets/loading_card.dart';
import 'package:flutter/material.dart';

Future<T?> showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future,
) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LoadingCard(),
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
