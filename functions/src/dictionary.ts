/* eslint-disable @typescript-eslint/no-explicit-any */
/* eslint-disable @typescript-eslint/no-non-null-assertion */
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";
import {firestore} from "firebase-admin";

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
          headword: entry.headword,
          language: entry.language,
          rand: Math.random(),
          lastUpdated: firestore.Timestamp.now(),
          forms: [
            entry.headword,
            ...(entry.forms?.map((s: any) => s.text) ?? []),
          ],
        } as any;
        if (entry.contribution) {
          base.unverified = true;
        }

        const records = [];

        for (const definition of entry.definitions) {
          const record = Object.assign({
            translation: definition.translation,
          }, base) as any;
          if (definition.tags?.length || entry.tags?.length) {
            record.tags = (definition.tags ?? []).concat(entry.tags ?? []);
          }
          if (definition.aliases?.length) {
            record.aliases = definition.aliases;
          }
          records.push(record);
        }
        await dictionary.saveObjects(
            records,
            {autoGenerateObjectIDIfNotExist: true}
        );
      }
    });
