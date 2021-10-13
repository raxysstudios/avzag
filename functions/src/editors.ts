import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


export const setEditorClaims = functions
    .region("europe-central2")
    .firestore.document("meta/editors")
    .onWrite(async (change) => {
      const auth = admin.auth();
      const users = {} as Record<string, Record<string, unknown> | null>;

      if (change.before.exists) {
        const editors = change.before.data() as Record<string, unknown>;
        for (const email of Object.keys(editors)) {
          users[email] = null;
        }
      }
      if (change.after.exists) {
        const editors = change.after.data() as Record<string, string[]>;
        for (const [email, languages] of Object.entries(editors)) {
          users[email] = {languages};
        }
      }

      for (const [email, claims] of Object.entries(users)) {
        const user = await auth.getUserByEmail(email);
        await auth.setCustomUserClaims(user.uid, claims);
      }
    });
