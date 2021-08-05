/* eslint-disable linebreak-style */
import * as admin from "firebase-admin";
import serviceAccountKey from "./secrets/serviceAccountKey.json";
admin.initializeApp({
  credential: admin.credential.cert(
    serviceAccountKey as admin.ServiceAccount
  ),
});
const auth = admin.auth();

// eslint-disable-next-line require-jsdoc
async function setClaims(data: Record<string, string[]>) {
  for (const [email, languages] of Object.entries(data)) {
    const user = await auth.getUserByEmail(email);
    await auth.setCustomUserClaims(user.uid, {languages});
  }
}

import editors from "./secrets/editors.json";
setClaims(editors);
