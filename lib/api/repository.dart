import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcodescanner/api/apps_api.dart';
import 'package:qrcodescanner/api/offers_api.dart';
import 'package:qrcodescanner/api/profile_api.dart';
import 'package:qrcodescanner/api/scanner_api.dart';
import 'package:qrcodescanner/api/settings_api.dart';
import 'package:qrcodescanner/model/offer.dart';
import 'package:qrcodescanner/model/profile.dart';
import 'package:qrcodescanner/model/scan.dart';
import 'package:qrcodescanner/model/settings.dart';

import 'auth_api.dart';

class Repository {
  final _authApi = AuthApi();
  final _profileApi = ProfileApi();
  final _scannerApi = ScannerApi();
  final _appsApi = AppsApi();
  final _settingsApi = SettingApi();
  final _offersApi = OffersApi();

  // Auth
  Future<User?> signInUser(String email, String password) async =>
      (await _authApi.signInUser(email, password)).user;
  Future<bool> forgotPassword(String email) async =>
      await _authApi.forgotPassword(email);
  Future<User?> signInWithGoogle() async =>
      (await _authApi.signInWithGoogle())!.user;
  Future<User?> signInWithFacebook() async =>
      (await _authApi.signInWithFacebook()).user;
  Future<User?> registerUser(
          String email, String password, String phone, String fullName) async =>
      (await _authApi.registerUser(email, password, phone, fullName)).user;
  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    int? forceResendingToken,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    return await _authApi.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: timeout,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  Future<User?> signInWithPhoneNumber(
          AuthCredential phoneAuthCredential) async =>
      (await _authApi.signInWithPhoneNumber(phoneAuthCredential)).user;
  Future<void> signOut() => _authApi.signOut();
  User? currentUser() => _authApi.currentUser();

  Future<Stream<DocumentSnapshot>> getMyProfile() async =>
      _profileApi.getProfile(currentUser()!.uid);
      Stream<DocumentSnapshot> getProfile(String uid) =>
      _profileApi.getProfile(uid);
  Future<DocumentSnapshot>? getMyProfileOnce() => _profileApi.getMyProfileOnce(currentUser()!.uid);
  Future<void> updateProfile(Profile newProfile) => _profileApi.updateProfile(newProfile);
  
  Stream<QuerySnapshot> getClientsProfiles() => _profileApi.getClientsProfiles();
  Stream<QuerySnapshot> getGuestsProfiles() => _profileApi.getGuestsProfiles();
  Stream<QuerySnapshot> getProfiles() => _profileApi.getProfiles();
  Stream<QuerySnapshot> getProfilesWithPremiumReq() => _profileApi.getProfilesWithPremiumReq();

  Stream<QuerySnapshot> getPremiumProfiles() => _profileApi.getPremiumProfiles();

  Future<void> addInvitedBy(String referral) => _profileApi.addInvitedBy(currentUser()!.uid, referral);


  Future<void> updateScan(Scan newContent) => _scannerApi.updateScan(newContent);
  Stream<QuerySnapshot> getMyScans() => _scannerApi.getMyScans(currentUser()!.uid);
  Stream<QuerySnapshot> getMyGeneratedScans() => _scannerApi.getMyGeneratedScans(currentUser()!.uid);
  Future<void> addMyScan(Scan scan) => _scannerApi.addMyScan(currentUser()!.uid, scan);
  Future<void> removeScan(String id) => _scannerApi.removeScan(id);
  

  Stream<QuerySnapshot> getMyFavorites() => _scannerApi.getMyFavorites(currentUser()!.uid);

  Stream<QuerySnapshot> getApps() => _appsApi.getApps();
  Stream<QuerySnapshot> getOffers() => _offersApi.getOffers(currentUser()!.uid);
  Future<void> claimOffer(Offer offer) => _offersApi.claimOffer(currentUser()!.uid, offer);

  Future<AppSettings> getSettings() => _settingsApi.getSettings();
}
