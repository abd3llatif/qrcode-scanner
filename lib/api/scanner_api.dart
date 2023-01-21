import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerApi {

  Future<void> updateScan(Scan newContent) {
    var map = {
      "text": newContent.text,
      "isLink": newContent.isLink,
      "isVCard": newContent.isVCard,
      "isWifi": newContent.isWifi,
      "isFav": newContent.isFav,
      "visible": newContent.visible
    };

    if (map['text'] == null) map.remove('text');
    if (map['isLink'] == null) map.remove('isLink');
    if (map['isVCard'] == null) map.remove('isVCard');
    if (map['isWifi'] == null) map.remove('isWifi');
    if (map['isFav'] == null) map.remove('isFav');
    if (map['visible'] == null) map.remove('visible');

    return FirebaseFirestore.instance
        .collection("scans")
        .doc(newContent.id)
        .update(map);
  }

  Future<void> addMyScan(String uid, Scan scan) async{
    DocumentReference doc = FirebaseFirestore.instance
        .collection('scans').doc();

    scan.id = doc.id;
    scan.isLink = scan.isLink ?? await canLaunch(scan.text!);
    scan.created = Timestamp.now();
    scan.owner = uid;
    scan.visible = true;
    scan.type = scan.type ?? 'scan';

    return doc.set(scan.toJson());
  }

  Stream<QuerySnapshot> getMyScans(String uid) {
    return FirebaseFirestore.instance
        .collection('scans')
        .where("owner", isEqualTo: uid)
        .where("visible", isEqualTo: true)
        .where("type", isEqualTo: 'scan')
        .orderBy("created", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyGeneratedScans(String uid) {
    return FirebaseFirestore.instance
        .collection('scans')
        .where("owner", isEqualTo: uid)
        .where("visible", isEqualTo: true)
        .where("type", isEqualTo: 'generated')
        .orderBy("created", descending: true)
        .snapshots();
  }

  Future<void> removeScan(String id) {
    return FirebaseFirestore.instance.collection('scans').doc(id).delete();
  }


  Stream<QuerySnapshot> getMyFavorites(String uid) {
    return FirebaseFirestore.instance
        .collection('scans')
        .where("owner", isEqualTo: uid)
        .where("visible", isEqualTo: true)
        .where("isFav", isEqualTo: true)
        .where("type", isEqualTo: 'scan')
        .orderBy("created", descending: true)
        .snapshots();
  }

}
