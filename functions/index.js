const functions = require("firebase-functions");
const admin = require("firebase-admin");

const Hashids = require("hashids/cjs");
const hashids = new Hashids(
    "iScanner",
    8,
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
);

admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();
const settings = {timestampInSnapshots: true};
firestore.settings(settings);

exports.generateReferral = functions.firestore
    .document("users/{id}")
    .onWrite((change, context) => {
        // on create
        if (!change.before.exists && change.after.exists) {
            // set referral for user
            return firestore
                .collection("users")
                .doc(change.after.data().id)
                .update({
                    referral: hashids.encode(Date.now()),
                });
            // on delete
        } else if (change.before.exists && !change.after.exists) {
            console.log("delete");
            return null;
            // update
        } else if (change.before.exists && change.after.exists) {
            if (change.before.data().invitedBy == null &&
                change.after.data().invitedBy != null &&
                change.after.data().invitedBy !== change.after.data().referral) {
                return firestore
                    .collection("users").where("referral", "==", change.after.data().invitedBy)
                    .get().then((querySnapshot) => {
                        return querySnapshot.forEach((docSnap) => {
                            const isPro = docSnap.data().points + 100 >= 500 ? true : false;
                            docSnap.ref.update({
                                points: docSnap.data().points + 100,
                                isPro: isPro,
                            });
                        });
                    }).then(() => {
                        const isPro = change.after.data().points + 100 >= 500 ? true : false;
                        return firestore
                            .collection("users")
                            .doc(change.after.data().id)
                            .update({
                                points: change.after.data().points + 100,
                                isPro: isPro,
                            });
                    }).catch((err) => {
                        console.log(err);
                        return null;
                    });
            }
            console.log("update");
            return null;
        }
        return null;
    });
