import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/api/repository.dart';

class AppsBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> getApps() => _repository.getApps();
}