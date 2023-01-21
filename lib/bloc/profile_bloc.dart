import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrcodescanner/api/repository.dart';
import 'package:qrcodescanner/model/profile.dart';
import 'package:qrcodescanner/utils/string_constants.dart';
import 'package:qrcodescanner/utils/validator.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc {
  final _repository = Repository();

  final _fullName = BehaviorSubject<String?>();
  final _phone = BehaviorSubject<String?>();
  final _email = BehaviorSubject<String?>();
  final _invitedBy = BehaviorSubject<String?>();

  Stream<String?> get fullName => _fullName.stream.transform(_validateName);
  Stream<String?> get phone => _phone.stream.transform(_validatePhone);
  Stream<String?> get email => _email.stream.transform(_validateEmail);
  Stream<String?> get invitedBy =>
      _invitedBy.stream.transform(_validateInvitedBy);

  Function(String?) get changeName => _fullName.sink.add;
  Function(String?) get changePhone => _phone.sink.add;
  Function(String?) get changeEmail => _email.sink.add;
  Function(String?) get changeInvitedBy => _invitedBy.sink.add;


  initBloc(Profile profile) {
    changeName(profile.fullName);

    changePhone(profile.phone);
    changeEmail(profile.email);

  }

  final _validateName =
      StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (Validator.isNameValid(name)) {
      sink.add(name);
    } else {
      sink.addError(StringConstants.userNameValidateMessage);
    }
  });

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validator.isEmail(email)) {
      sink.add(email);
    } else {
      sink.addError(StringConstants.emailValidateMessage);
    }
  });

  final _validatePhone =
      StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (Validator.isPhoneValid(phone)) {
      sink.add(phone);
    } else {
      sink.addError(StringConstants.phoneValidateMessage);
    }
  });

  final _validateInvitedBy = StreamTransformer<String, String>.fromHandlers(
      handleData: (invitedBy, sink) {
    if (invitedBy.isNotEmpty) {
      sink.add(invitedBy);
    } else {
      sink.addError(StringConstants.invitationCodeNotValid);
    }
  });


  void dispose() async {
    // changeName(null!);
    // changePhone(null!);
    // changeEmail(null!);
    // changeInvitedBy(null!);

    await _fullName.drain();
    _fullName.close();
    await _email.drain();
    _email.close();
    await _phone.drain();
    _phone.close();
    await _invitedBy.drain();
    _invitedBy.close();
  }

  Future<Stream<DocumentSnapshot>> getMyProfile() => _repository.getMyProfile();
  // Future<DocumentSnapshot> getMyProfileOnce() => _repository.getMyProfileOnce();

  bool updateFullName(String profileId) {
    try {
      if (Validator.isNameValid(_fullName.value)) {
        Profile profile = Profile(
            fullName: _fullName.value,
            email: _email.value,
            phone: _phone.value,
            id: profileId);
        _repository.updateProfile(profile);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool updatePhone(String profileId) {
    try {
      if (Validator.isPhoneValid(_phone.value)) {
        Profile profile = Profile(
            fullName: _fullName.value,
            email: _email.value,
            phone: _phone.value,
            id: profileId);
        _repository.updateProfile(profile);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  

  bool updateEmail(String profileId) {
    try {
      if (Validator.isEmail(_email.value)) {
        Profile profile = Profile(
            fullName: _fullName.value,
            email: _email.value,
            phone: _phone.value,
            id: profileId);
        _repository.updateProfile(profile);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // bool addInvitedBy(String profileId) {
  //   try {
  //     if (_invitedBy.value != null && _invitedBy.value!.isNotEmpty) {
  //       Profile profile = Profile(id: profileId);
  //       _repository.updateProfile(profile);
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  bool updateProfileForm(String profileId) {
    try {
      if (Validator.isPhoneValid(_phone.value) &&
          Validator.isEmail(_email.value) &&
          Validator.isNameValid(_fullName.value)) {
        Profile profile = Profile(
          fullName: _fullName.value,
          email: _email.value,
          phone: _phone.value,
          id: profileId,
        );
        _repository.updateProfile(profile);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> updateProfile(profile) => _repository.updateProfile(profile);

  Future<bool> updateCompleteProfile(Profile newProfile) async {
    try {
        await _repository.updateProfile(newProfile);
        return true;
    } catch (e) {
      return false;
    }
  }


  Stream<QuerySnapshot> getClientsProfiles() => _repository.getClientsProfiles();
  Stream<QuerySnapshot> getGuestsProfiles() => _repository.getGuestsProfiles();

  Stream<DocumentSnapshot> getProfile(String uid) => _repository.getProfile(uid);

  Stream<QuerySnapshot> getProfiles() => _repository.getProfiles();

  Stream<QuerySnapshot> getProfilesWithPremiumReq() => _repository.getProfilesWithPremiumReq();

  Stream<QuerySnapshot> getPremiumProfiles() => _repository.getPremiumProfiles();


  Future<DocumentSnapshot>? getMyProfileOnce() => _repository.getMyProfileOnce();

  Future<void> addInvitedBy(String referral) => _repository.addInvitedBy(referral);

}
