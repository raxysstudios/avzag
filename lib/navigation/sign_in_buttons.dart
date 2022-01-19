import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;

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
    String generateNonce([int length = 32]) {
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    if (kIsWeb) {
      final provider = OAuthProvider('apple.com')
        ..addScope('email')
        ..addScope('name');
      await FirebaseAuth.instance.signInWithPopup(provider);
    } else {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      var redirectURL = 'https://andaxapp.firebaseapp.com/__/auth/handler';
      var clientID = 'andaxapp';
      final appleIdCredential =
          await apple.SignInWithApple.getAppleIDCredential(
        scopes: [
          apple.AppleIDAuthorizationScopes.email,
          apple.AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: apple.WebAuthenticationOptions(
            clientId: clientID, redirectUri: Uri.parse(redirectURL)),
        nonce: nonce,
      );
      // Create an `OAuthCredential` from the credential returned by Apple.
      return OAuthProvider('apple.com').credential(
        idToken: appleIdCredential.identityToken,
        accessToken: appleIdCredential.authorizationCode,
        rawNonce: rawNonce,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    if (FirebaseAuth.instance.currentUser != null) {
      final user = FirebaseAuth.instance.currentUser!;
      return ListTile(
        leading: CircleAvatar(
          backgroundImage:
              user.photoURL == null ? null : NetworkImage(user.photoURL!),
          backgroundColor: Colors.transparent,
        ),
        title: Text(user.displayName ?? '[no name]'),
        subtitle: Text(user.email ?? '[no email]'),
        trailing: IconButton(
          onPressed: signOut,
          icon: const Icon(Icons.logout_rounded),
          tooltip: 'Sign out',
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => signIn(getGoogleCredentials),
              icon: const Icon(Icons.login_rounded),
              label: const Text('Google Sign In'),
            ),
          ),
          if (kIsWeb || Platform.isIOS) ...[
            const SizedBox(width: 8),
            Expanded(
              child: TextButton.icon(
                onPressed: () => signIn(getAppleCredentials),
                icon: const Icon(Icons.login_rounded),
                label: const Text('Apple Sign In'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
