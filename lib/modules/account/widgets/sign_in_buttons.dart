import 'dart:async';
import 'dart:io';

import 'package:avzag/shared/modals/snackbar_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/credentials.dart';
import '../services/signing.dart' as signing;

class SignInButtons extends StatefulWidget {
  const SignInButtons({
    this.onSingIn,
    Key? key,
  }) : super(key: key);

  final FutureOr<void> Function()? onSingIn;

  @override
  State<SignInButtons> createState() => _SignInButtonsState();
}

class _SignInButtonsState extends State<SignInButtons> {
  var loading = false;

  Future<void> signIn(
    Future<AuthCredential?> Function() credentialsGetter,
  ) async {
    setState(() {
      loading = true;
    });
    try {
      if (await signing.signIn(credentialsGetter) == true) {
        await widget.onSingIn?.call();
      }
    } catch (e) {
      showSnackbar(context);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: loading
          ? const Center(
              child: SizedBox.square(
                dimension: 24,
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: () => signIn(getGoogleCredentials),
                  icon: const Icon(Icons.login_rounded),
                  label: const Text('Sign in with Google'),
                ),
                if (kIsWeb || Platform.isIOS) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => signIn(getAppleCredentials),
                    icon: const Icon(Icons.login_rounded),
                    label: const Text('Sign in with Apple'),
                  ),
                ],
              ],
            ),
    );
  }
}
