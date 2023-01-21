import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/model/profile.dart';

class ProfileApi {
  Stream<DocumentSnapshot> getProfile(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  Future<DocumentSnapshot> getMyProfileOnce(String uid) {
    return FirebaseFirestore.instance.collection('users').doc(uid).get();
  }

  Future<void> updateProfile(Profile newProfile) {
    var map = {
      "fullName": newProfile.fullName,
      "phone": newProfile.phone,
      "email": newProfile.email,
      "fcm": newProfile.fcm,
      "isPro": newProfile.isPro,
      "isAdmin": newProfile.isAdmin,
    };

    if (map['fullName'] == null) map.remove('fullName');
    if (map['phone'] == null) map.remove('phone');
    if (map['email'] == null) map.remove('email');
    if (map['fcm'] == null) map.remove('fcm');
    if (map['isPro'] == null) map.remove('isPro');
    if (map['isAdmin'] == null) map.remove('isAdmin');

    return FirebaseFirestore.instance
        .collection("users")
        .doc(newProfile.id)
        .update(map);
  }

  Future<void> addInvitedBy(String uid, String referral) async {
    
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
          "invitedBy": referral
        });
  }

  Stream<QuerySnapshot> getClientsProfiles() {
    return FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "artist")
        .snapshots();
  }

  Stream<QuerySnapshot> getGuestsProfiles() {
    return FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "user")
        .snapshots();
  }

  Stream<DocumentSnapshot> getMyProgression(String uid) {
    return FirebaseFirestore.instance
        .collection('progression')
        .doc(uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getProfiles() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy("created", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPremiumProfiles() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('isPro', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getProfilesWithPremiumReq() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('wantTobePro', isEqualTo: true)
        .orderBy("created", descending: true)
        .snapshots();
  }
}
