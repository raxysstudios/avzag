import * as admin from "firebase-admin";
import * as functions from "firebase-functions";
import algoliasearch from "algoliasearch";

const dictionary = algoliasearch(
    functions.config().algolia.app,
    functions.config().algolia.key
).initIndex("dictionary");

export const collectStats = functions
    .region("europe-central2")
    .pubsub.schedule("every 6 hours")
    .timeZone("Europe/Moscow")
    .onRun(async () => {
      const db = admin.firestore();
      const langs = await db
          .collection("languages").get()
          .then((d) => d.docs.map((l) => l.id));

      for (const lang of langs) {
        await db.doc("languages/" + lang).update({
          stats: {
            dictionary: await dictionary
                .search("", {
                  facetFilters: ["language:" + lang],
                  hitsPerPage: 0,
                }).then((s) => s.nbHits),
          },
        });
      }
    });
