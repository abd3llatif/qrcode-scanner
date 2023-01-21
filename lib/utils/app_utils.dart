// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:qrcodescanner/utils/constants.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:wifi_connector/wifi_connector.dart';



class AppUtils {

  static updateFCMToken() async {
    if (FirebaseAuth.instance.currentUser != null) {
      String fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
      FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.uid).update({
          'fcm': fcmToken
        });
    }
  }

  static void shareApp(String referral, points) {
    if(Platform.isAndroid) {
      Share.share("Hi, Download ${Constants.ANDROID_LINK} and use my code ( $referral ) to get free $points point.");
    } else if(Platform.isIOS) {
      Share.share("Hi, Download ${Constants.IOS_LINK} and use my code ( $referral ) to get free $points point.");
    }}

  static void shareScan(String text) {
    Share.share(text);
  }

  static void sendEmail(email) async {
    String url = "mailto:$email";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static void call(phone) async {
    String url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static openLink(String link) async {
    if (!link.toLowerCase().contains("http")) link = 'http://$link';
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      throw 'Could not launch $link';
    }
  }

  static addContact(Contact contact) async {
    await ContactsService.addContact(contact);
  }

  // static Future<bool> connectToWifi(ssid, password, type) async {
  //   return await WifiConnector.connectToWifi(ssid: ssid, password: password, isWEP: type == "WPA");
  //   // return await Wifi.connection(ssid, password);
  // }

  static iSendSMS(phone, message) async {
    String _result = await sendSMS(message: message, recipients: [phone])
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
