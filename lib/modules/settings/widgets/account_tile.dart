import 'dart:async';
import 'dart:io';

import 'package:avzag/shared/modals/snackbar_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/credentials.dart';
import '../services/signing.dart';

class AccountTile extends StatefulWidget {
  const AccountTile({Key? key}) : super(key: key);

  @override
  State<AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<AccountTile> {
  late final StreamSubscription<User?> _authStream;
  var loading = false;

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges().listen(
          (_) => setState(() {}),
        );
  }

  @override
  void dispose() {
    _authStream.cancel();
    super.dispose();
  }

  Future<void> _signIn(
    Future<AuthCredential?> Function() credentialsGetter,
  ) async {
    setState(() {
      loading = true;
    });
    try {
      await signIn(credentialsGetter);
    } catch (e) {
      showSnackbar(context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return loading
          ? const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(),
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    onPressed: () => _signIn(getGoogleCredentials),
                    icon: const Icon(Icons.login_outlined),
                    label: const Text('Sign in with Google'),
                  ),
                ),
                if (kIsWeb || Platform.isIOS)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextButton.icon(
                      onPressed: () => _signIn(getAppleCredentials),
                      icon: const Icon(Icons.login_outlined),
                      label: const Text('Sign in with Apple'),
                    ),
                  ),
              ],
            );
    }
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.photoURL == null ? null : NetworkImage(user.photoURL!),
        backgroundColor: Colors.transparent,
      ),
      title: Text(user.displayName ?? '[no name]'),
      subtitle: Text(user.email ?? '[no email]'),
      trailing: const IconButton(
        onPressed: signOut,
        icon: Icon(Icons.logout_outlined),
        tooltip: 'Sign out',
      ),
    );
  }
}
