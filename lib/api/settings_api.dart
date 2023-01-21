import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/settings.dart';

class SettingApi {
  Future<AppSettings> getSettings() async {
    return AppSettings.fromDoc(await FirebaseFirestore.instance
        .collection('settings')
        .doc('v1')
        .get());
  }
}
