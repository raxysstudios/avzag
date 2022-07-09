import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> signIn(
  Future<AuthCredential?> Function() getCredentials,
) async {
  final credentials = await getCredentials();
  if (credentials == null) return false;
  await FirebaseAuth.instance.signInWithCredential(credentials);
  return true;
}

Future<bool> signOut([User? user]) async {
  final provider = (user ?? FirebaseAuth.instance.currentUser)
      ?.providerData
      .first
      .providerId;
  if (provider == null) return false;

  await FirebaseAuth.instance.signOut();
  switch (provider) {
    case 'google.com':
      await GoogleSignIn().signOut();
      break;
  }
  return true;
}
