import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

admin.initializeApp();
const index = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
)
    .initIndex("dictionary");

/**
 * Perform indexation
 * @constructor
 * @param {functions.firestore.QueryDocumentSnapshot} change
 * - The title of the book.
 * @param {functions.EventContext} context
 *  - The author of the book.
 */
function applyIndexing(
    change: functions.firestore.QueryDocumentSnapshot,
    context: functions.EventContext
) {
  const entry = change.data();
  const base = {
    entryID: context.params.entryID,
    language: context.params.language,
    forms: entry.forms.map(({plain}: never) => plain),
  };

  type Record = {
    entryID: string;
    language: string;
    forms: string[]
    term: string;
    definition: string | undefined;
    tags: string[] | undefined;
  };
  const records = [];

  for (const use of entry.uses) {
    const record = Object.assign({term: use.term}, base) as Record;
    const tags = [].concat(...(entry.tags ?? []), ...(use.tags ?? []));
    if (tags?.length) {
      record.tags = tags;
    }
    if (use.definition) {
      record.definition = use.definition;
    }
    records.push(record);
  }

  return index.saveObjects(
      records,
      {autoGenerateObjectIDIfNotExist: true}
  );
}

export const addToIndex = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onCreate(applyIndexing);

export const updateIndex = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onUpdate(async (change, context) => {
      await index.deleteBy({
        filters: "entryID:" + context.params.entryID,
      });
      applyIndexing(change.after, context);
    });

export const deleteFromIndex = functions
    .region("europe-central2")
    .firestore.document("languages/{language}/dictionary/{entryID}")
    .onDelete((_, context) => index.deleteBy({
      filters: "entryID:" + context.params.entryID,
    }));
