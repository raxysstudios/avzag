import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

const dictionary = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
).initIndex("dictionary");

type EntryRecord = {
    entryID: string;
    language: string;
    headword: string;
    forms: string[];
    aliases: string[],
    term: string;
    definition: string | undefined;
    tags: string[] | undefined;
};

export const indexDictionary = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onWrite(async (change, context) => {
      if (change.before.exists) {
        await dictionary.deleteBy({
          filters: "entryID:" + context.params.entryID,
        });
      }
      if (change.after.exists) {
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        const entry = change.after.data()!;
        const base = {
          entryID: context.params.entryID,
          language: context.params.language,
          forms: entry.forms.map(({plain}: never) => plain),
          headword: entry.forms[0].plain,
        };
        const records = [];

        for (const use of entry.uses) {
          const record = Object.assign({term: use.term}, base) as EntryRecord;
          if (use.tags?.length || entry.tags?.length) {
            record.tags = (use.tags ?? []).concat(entry.tags ?? []);
          }
          if (use.aliases?.length) {
            record.aliases = use.aliases;
          }
          if (use.definition) {
            record.definition = use.definition;
          }
          records.push(record);
        }
        await dictionary.saveObjects(
            records,
            {autoGenerateObjectIDIfNotExist: true}
        );
      }
    });
