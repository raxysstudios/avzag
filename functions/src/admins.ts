/* eslint-disable @typescript-eslint/no-non-null-assertion */
import * as functions from "firebase-functions";
import * as admin from "firebase-admin";


export const setAdminClaims = functions
    .region("europe-central2")
    .firestore.document("users/{uid}")
    .onWrite(async (change, context) =>
      await admin.auth().setCustomUserClaims(
          context.params.uid,
          change.after.exists ? {
            admin: change.after.data()!.admin,
          } : null
      )
    );
