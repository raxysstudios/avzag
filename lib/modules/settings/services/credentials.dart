import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart' as apple;

import 'crypto.dart';

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
    final appleIdCredential = await apple.SignInWithApple.getAppleIDCredential(
      scopes: [
        apple.AppleIDAuthorizationScopes.email,
        apple.AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: apple.WebAuthenticationOptions(
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
