import 'package:flutter/material.dart';

void showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future, {
  ValueSetter<T>? callback,
}) {
  var dismissed = false;
  final dismissible = callback != null;
  showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) {
      return WillPopScope(
        onWillPop: () => Future.value(dismissible),
        child: Center(
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
        ),
      );
    },
  ).then((_) => dismissed = true);

  future.then((result) {
    if (!dismissed) if (result != null) callback?.call(result);
  }).catchError((error) {
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
  }).whenComplete(() {
    if (!dismissed) Navigator.pop(context);
  });
}
