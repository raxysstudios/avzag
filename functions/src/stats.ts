import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

const dictionary = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
).initIndex("dictionary");

export const collectStats = functions
    .region("europe-central2")
    .pubsub.schedule("0 5 * * *")
    .timeZone("Europe/Moscow")
    .onRun(async () => {
      const db = admin.firestore();
      const langs = await db
          .collection("languages").get()
          .then((d) => d.docs.map((l) => l.id));
      const editors = await db
          .doc("meta/editors").get()
          .then((d) => d.data() as Record<string, string[]>);

      for (const lang of langs) {
        await db.doc("languages/" + lang).update({
          stats: {
            editors: Object
                .values(editors)
                .filter((ls) => ls.includes(lang))
                .length,
            dictionary: await dictionary
                .search("", {
                  "facetFilters": ["language:"+lang],
                }).then((s) => s.nbHits),
          },
        });
      }
    });
