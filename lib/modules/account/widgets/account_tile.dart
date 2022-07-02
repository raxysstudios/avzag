import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/signing.dart';

class AccountTile extends StatelessWidget {
  const AccountTile(
    this.user, {
    this.onSignOut,
    Key? key,
  }) : super(key: key);

  final User user;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.photoURL == null ? null : NetworkImage(user.photoURL!),
        backgroundColor: Colors.transparent,
      ),
      title: Text(user.displayName ?? '[no name]'),
      subtitle: Text(user.email ?? '[no email]'),
      trailing: onSignOut == null
          ? null
          : IconButton(
              onPressed: () async {
                if (await signOut(user) == true) onSignOut?.call();
              },
              icon: const Icon(Icons.logout_outlined),
              tooltip: 'Sign out',
            ),
    );
  }
}
