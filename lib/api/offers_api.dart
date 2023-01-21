import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/model/offer.dart';
import 'package:qrcodescanner/model/profile.dart';

class OffersApi {
  Stream<QuerySnapshot> getOffers(String uid) {
    return FirebaseFirestore.instance
        .collection('offers')
        .where("claimed", isEqualTo: false)
        .where("to", isEqualTo: uid)
        .snapshots();
  }

  Future<void> claimOffer(String uid, Offer offer) async {
    Profile profile = Profile.fromDoc(
        await FirebaseFirestore.instance.collection('users').doc(uid).get());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({"points": (profile.points ?? 0) + (offer.points ?? 0)});

    return FirebaseFirestore.instance
        .collection('offers')
        .doc(offer.id)
        .update({"claimed": true});
  }
}
