import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInButtons extends StatefulWidget {
  const SignInButtons({
    this.onSignOut,
    this.onSingIn,
    Key? key,
  }) : super(key: key);

  final FutureOr<void> Function()? onSingIn;
  final FutureOr<void> Function()? onSignOut;

  @override
  _SignInButtonsState createState() => _SignInButtonsState();
}

class _SignInButtonsState extends State<SignInButtons> {
  var loading = false;

  Future<void> signIn(
    Future<AuthCredential?> Function() getCredentials,
  ) async {
    await signOut();
    setState(() {
      loading = true;
    });
    final credentials = await getCredentials();
    if (credentials != null) {
      await FirebaseAuth.instance.signInWithCredential(credentials);
      await widget.onSingIn?.call();
    }
    setState(() {
      loading = false;
    });
  }

  Future<void> signOut() async {
    setState(() {
      loading = true;
    });
    final provider =
        FirebaseAuth.instance.currentUser?.providerData.first.providerId;
    if (provider == null) return;

    await FirebaseAuth.instance.signOut();
    switch (provider) {
      case 'google.com':
        await GoogleSignIn().signOut();
        break;
      case 'apple.com':
        // TODO await appleSignOut;
        break;
      default:
    }
    await widget.onSignOut?.call();
    setState(() {
      loading = false;
    });
  }

  Future<AuthCredential?> getGoogleCredentials() async {
    final user = await GoogleSignIn().signIn();
    if (user != null) {
      final auth = await user.authentication;
      return GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
    }
  }

  Future<AuthCredential?> getAppleCredentials() async {
    // TODO
    // final user = await GoogleSignIn().signIn();
    // if (user != null) {
    //   final auth = await user.authentication;
    //   return GoogleAuthProvider.credential(
    //     accessToken: auth.accessToken,
    //     idToken: auth.idToken,
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox.square(
            dimension: 30,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser!;
      return TextButton.icon(
        onPressed: signOut,
        icon: const Icon(Icons.logout_rounded),
        label: Text(
          user.email ?? user.displayName ?? 'Some User',
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            'Sign in with',
            style: Theme.of(context).textTheme.button,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => signIn(getGoogleCredentials),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Google'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => signIn(getAppleCredentials),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Apple'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
