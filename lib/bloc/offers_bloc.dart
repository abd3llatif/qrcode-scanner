import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/api/repository.dart';
import 'package:qrcodescanner/model/offer.dart';

class OffersBloc {
  final _repository = Repository();

  Stream<QuerySnapshot> getOffers() => _repository.getOffers();
  Future<void> claimOffer(Offer offer) => _repository.claimOffer(offer);
}