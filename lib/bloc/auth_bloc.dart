import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qrcodescanner/api/repository.dart';
import 'package:qrcodescanner/utils/validator.dart';

import 'package:rxdart/rxdart.dart';

class AuthBloc {
  final _repository = Repository();

  late BehaviorSubject<User?> _authStateChangedControllers;
  late Stream<User?> _user;

  AuthBloc() {
    _authStateChangedControllers = BehaviorSubject<User>();
    _user = _authStateChangedControllers.stream;

    if (_repository.currentUser() != null) {
      _authStateChangedControllers.add(_repository.currentUser()!);
    }
  }

  final _validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validator.isEmail(email)) {
      sink.add(email);
    } else {
      sink.addError('Email not valid');
    }
  });

  Future<User?> signInWithGoogle() async {
    try {
      User? user = (await _repository.signInWithGoogle());
      _authStateChangedControllers.add(user!);
      return user;
    } catch (e) {
      _authStateChangedControllers.addError(e);
      return Future.error(e);
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      User? user = (await _repository.signInWithFacebook());
      _authStateChangedControllers.add(user!);
      return user;
    } catch (e) {
      _authStateChangedControllers.addError(e);
      return Future.error(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _repository.signOut();
      _authStateChangedControllers.add(null);
    } catch (e) {
      _authStateChangedControllers.addError(e);
      return;
    }
  }

  Stream<User?> get user => _user;
}
