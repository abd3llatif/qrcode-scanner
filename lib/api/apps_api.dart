import 'package:cloud_firestore/cloud_firestore.dart';

class AppsApi {

  Stream<QuerySnapshot> getApps() {
    return FirebaseFirestore.instance
        .collection('apps')
        .snapshots();
  }

}