import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const index = algoliasearch(
        functions.config().algolia.app,
        functions.config().algolia.key
    )
    .initIndex('dictionary');
    
export const addToIndex = functions.firestore
    .document('languages/{language}/dictionary/{entryID}')
    .onCreate(async (change, context) => {
        const data = change.data();
        const baseEntry = {
            entryID: context.params.entryID,
            language: context.params.language,
            forms: data.forms,
        };

        const entries = [];
        for (const { conceptID } of data.uses) {
            const concept = await admin.firestore()
                .doc('meta/dictionary/concepts/' + conceptID)
                .get()
                .then(d => d.data());
            entries.push(Object.assign({ conceptID, ...concept }, baseEntry));
        }

        return index.saveObjects(entries, { autoGenerateObjectIDIfNotExist: true });
    });

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
