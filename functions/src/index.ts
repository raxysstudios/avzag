import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const index = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
)
    .initIndex("dictionary");

type EntryRecord = {
    entryID: string;
    language: string;
    headword: string;
    forms: string[];
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
          const tags = [].concat(...(entry.tags ?? []), ...(use.tags ?? []));
          if (tags?.length) {
            record.tags = tags.map((t) => "#" + t);
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
      }
    });

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
