import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi {
  /*
   add futures :
      email verification
      handle errors
      {
        • `ERROR_WEAK_PASSWORD` - If the password is not strong enough.
        • `ERROR_INVALID_EMAIL` - If the email address is malformed.
        • `ERROR_EMAIL_ALREADY_IN_USE` - If the email is already in use by a different account.
      }
    */

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = FacebookLogin();

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  Future<UserCredential> signInUser(String email, password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password)
      ..then((result) {
        _firestore
            .collection("users")
            .doc(result.user!.uid)
            .update({'lastSignIn': Timestamp.now()});
      })
      ..catchError((e) {
        // handle error
      });
  }

  Future<UserCredential> registerUser(
      String email, String password, String phone, String fullName) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
      ..then((result) {
        _firestore.collection("users").doc(result.user!.uid).set({
          'email': result.user!.email,
          'phone': result.user!.phoneNumber,
          'fullName': result.user!.displayName,
          'id': result.user!.uid,
          'created': Timestamp.now(),
          'lastSignIn': Timestamp.now(),
          'fcm': null,
          'referral': null,
          'isPro': false,
          'isAdmin': false,
          'sharedWith': 0,
          'points': 0,
          'invitedBy': null,
        });

        // First time to register
        firstTimeRegister();
      })
      ..catchError((e) {});
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return Future.value(true);
    } on Exception {
      return Future.value(false);
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    facebookSignIn.loginBehavior = FacebookLoginBehavior.webOnly;
    
    final FacebookLoginResult facebookUser =
        await facebookSignIn.logIn(['email']);

    final AuthCredential credential = FacebookAuthProvider.credential(
      facebookUser.accessToken.token,
    );

    return _auth.signInWithCredential(credential)
      ..then((result) {
        DocumentReference docRef =
            _firestore.collection("users").doc(result.user!.uid);
        docRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            docRef.update({'lastSignIn': Timestamp.now()});
          } else {
            docRef.set({
              'email': result.user!.email,
              'phone': result.user!.phoneNumber,
              'fullName': result.user!.displayName,
              'id': result.user!.uid,
              'created': Timestamp.now(),
              'lastSignIn': Timestamp.now(),
              'fcm': null,
              'referral': null,
              'isPro': false,
              'isAdmin': false,
              'sharedWith': 0,
              'points': 0,
              'invitedBy': null,
            });

            // First time to register
            firstTimeRegister();
            
          }
        });
      })
      ..catchError((e) {
        // handle error
      });
  }

  firstTimeRegister() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setBool('FT', true);
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return _auth.signInWithCredential(credential)
        ..then((result) {
          DocumentReference docRef =
              _firestore.collection("users").doc(result.user!.uid);
          docRef.get().then((docSnapshot) {
            if (docSnapshot.exists) {
              docRef.update({'lastSignIn': Timestamp.now()});
            } else {
              docRef.set({
                'email': result.user!.email,
                'phone': result.user!.phoneNumber,
                'fullName': result.user!.displayName,
                'id': result.user!.uid,
                'created': Timestamp.now(),
                'lastSignIn': Timestamp.now(),
                'fcm': null,
                'referral': null,
                'isPro': false,
                'isAdmin': false,
                'sharedWith': 0,
                'points': 0,
              'invitedBy': null,
              });

              // First time to register
              firstTimeRegister();
            }
          });
        })
        ..catchError((e) {
          // handle error
          print("erroroororo");
        });
    } catch (error) {
      print(error);
    }
  }

  Future<bool> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeout,
    int? forceResendingToken,
    required PhoneVerificationCompleted verificationCompleted,
    required PhoneVerificationFailed verificationFailed,
    required PhoneCodeSent codeSent,
    required PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
      return Future.value(true);
    } on Exception {
      return Future.value(false);
    }
  }

  Future<UserCredential> signInWithPhoneNumber(
      AuthCredential phoneAuthCredential) async {
    return _auth.signInWithCredential(phoneAuthCredential)
      ..then((result) {
        DocumentReference docRef =
            _firestore.collection("users").doc(result.user!.uid);
        docRef.get().then((docSnapshot) {
          if (docSnapshot.exists) {
            docRef.update({'lastSignIn': Timestamp.now()});
          } else {
            docRef.set({
              'email': result.user!.email,
              'phone': result.user!.phoneNumber,
              'fullName': result.user!.displayName,
              'id': result.user!.uid,
              'created': Timestamp.now(),
              'lastSignIn': Timestamp.now(),
              'fcm': null,
              'referral': null,
              'isPro': false,
              'isAdmin': false,
              'sharedWith': 0,
              'points': 0,
              'invitedBy': null,
            });

            // First time to register
            firstTimeRegister();
          }
        });
      })
      ..catchError((e) {
        // handle error
      });
  }

  User? currentUser() => _auth.currentUser;

  Future<void> signOut() => _auth.signOut();
}
