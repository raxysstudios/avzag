import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        child: const Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
