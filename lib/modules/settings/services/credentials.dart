import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Future<AuthCredential?> getGoogleCredentials() async {
  final user = await GoogleSignIn().signIn();
  if (user != null) {
    final auth = await user.authentication;
    return GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
  }
  return null;
}

Future<AuthCredential?> getAppleCredentials() async {
  if (kIsWeb) {
    final provider = OAuthProvider('apple.com')
      ..addScope('email')
      ..addScope('name');
    await FirebaseAuth.instance.signInWithPopup(provider);
  } else {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    var redirectURL = 'https://avzagapp.firebaseapp.com/__/auth/handler';
    var clientID = 'avzagapp';
    final appleIdCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: clientID,
        redirectUri: Uri.parse(redirectURL),
      ),
      nonce: nonce,
    );
    // Create an `OAuthCredential` from the credential returned by Apple.
    return OAuthProvider('apple.com').credential(
      idToken: appleIdCredential.identityToken,
      accessToken: appleIdCredential.authorizationCode,
      rawNonce: rawNonce,
    );
  }
  return null;
}

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
