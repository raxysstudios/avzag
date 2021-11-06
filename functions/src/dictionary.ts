/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

const dictionary = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
).initIndex("dictionary");


export const indexDictionary = functions
    .region("europe-central2")
    .firestore.document("dictionary/{entryID}")
    .onWrite(async (change, context) => {
      const entryID = context.params.entryID;
      if (change.before.exists) {
        await dictionary.deleteBy({
          filters: "entryID:" + entryID,
        });
      }
      if (change.after.exists) {
        const entry = change.after.data()!;
        const base = {
          entryID,
          language: entry.language,
          forms: entry.forms.map(({plain}: never) => plain),
          headword: entry.forms[0].plain,
        } as any;
        if (entry.contribution) {
          base.unverified = true;
        }

        const records = [];

        for (const use of entry.uses) {
          const record = Object.assign({term: use.term}, base) as any;
          if (use.tags?.length || entry.tags?.length) {
            record.tags = (use.tags ?? []).concat(entry.tags ?? []);
          }
          if (use.aliases?.length) {
            record.aliases = use.aliases;
          }
          records.push(record);
        }
        await dictionary.saveObjects(
            records,
            {autoGenerateObjectIDIfNotExist: true}
        );
      }
    });
