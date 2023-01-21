import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/api/repository.dart';
import 'package:qrcodescanner/model/scan.dart';

class ScannerBloc {

final _repository = Repository();


  Future<void> updateScan(Scan newContent) => _repository.updateScan(newContent);
  Stream<QuerySnapshot> getMyScans() => _repository.getMyScans();
  Stream<QuerySnapshot> getMyGeneratedScans() => _repository.getMyGeneratedScans();
  Future<void> addMyScan(Scan scan) => _repository.addMyScan(scan);
  Future<void> removeScan(String id) => _repository.removeScan(id);

  Stream<QuerySnapshot> getMyFavorites() => _repository.getMyFavorites();

}