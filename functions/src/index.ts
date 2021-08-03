import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const index = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
)
    .initIndex("dictionary");

type Record = {
  entryID: string;
  language: string;
  headword: string,
  forms: string[]
  term: string;
  definition: string | undefined;
  tags: string[] | undefined;
};

export const indexDictionary = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onWrite(async (change, context) => {
      if (change.before.exists) {
        await index.deleteBy({
          filters: "entryID:" + context.params.entryID,
        });
      }

      const entry = change.after.data();
      if (!entry) return;

      const base = {
        entryID: context.params.entryID,
        language: context.params.language,
        forms: entry.forms.map(({plain}: never) => plain),
        headword: entry.forms[0].plain,
      };
      const records = [];

      for (const use of entry.uses) {
        const record = Object.assign({term: use.term}, base) as Record;
        const tags = [].concat(...(entry.tags ?? []), ...(use.tags ?? []));
        if (tags?.length) {
          record.tags = tags.map((t) => "#"+t);
        }
        if (use.definition) {
          record.definition = use.definition;
        }
        records.push(record);
      }

      await index.saveObjects(
          records,
          {autoGenerateObjectIDIfNotExist: true}
      );
    });
