import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const index = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
)
    .initIndex("dictionary");

export const addToIndex = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onCreate(async (change, context) => {
      const entry = change.data();
      const base = {
        entryID: context.params.entryID,
        language: context.params.language,
        forms: entry.forms.map(({plain}: never) => plain),
      };

      type SearchObject = {
        entryID: string;
        language: string;
        forms: string[]
        term: string;
        definition: string | undefined;
        tags: string[] | undefined;
      };
      const searchObjects = [];
      for (const use of entry.uses) {
        const tags = [].concat(...(entry.tags ?? []), ...(use.tags ?? []));
        const object = Object.assign({term: use.term}, base) as SearchObject;
        if (tags?.length) {
          object.tags = tags;
        }
        if (use.definition) {
          object.definition = use.definition;
        }
        searchObjects.push(object);
      }

      return index.saveObjects(
          searchObjects,
          {autoGenerateObjectIDIfNotExist: true}
      );
    });

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
