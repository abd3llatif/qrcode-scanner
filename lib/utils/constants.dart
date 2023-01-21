// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:flutter/material.dart';

class Constants {
  static var API_URL =  "";

  static const String APP_NAME = "iScanner";
  static const String APP_LINK = "http://google.com";
  static const String APP_VERSION = "v1.1";

  static const String ANDROID_LINK = "https://play.google.com/store/apps/details?id=ma.goviral.qrcodescanner";
  static const String IOS_LINK = "";

  //ADMOB
  static String ANDROID_APP_ID = "ca-app-pub-8630423092275079~1261333941";
  static String ANDROID_BANNER_AD_ID = "ca-app-pub-8630423092275079/7402364173";
  static String ANDROID_INTERSTITIAL_AD_ID = "ca-app-pub-8630423092275079/2191272235";

  static String IOS_APP_ID = "";
  static String IOS_BANNER_AD_ID = "";
  static String IOS_INTERSTITIAL_AD_ID = "";

  static int REPEAT_INTERSTITIAL = 3;

  static bool SHOW_BANNER = true;
  static bool SHOW_INTERSTITIAL = true;

  static bool SHOW_FREEADS_OFFER = true;

  static int SHARE_WITH = 10;

  static Map? ANNOUNCEMENTS = {};

  // Style constants
  // Colors https://www.colorcombos.com/color-schemes/7/ColorCombo7.html
  static const Color COLOR_PRIMARY = Color(0xFF15274B);
  static const Color COLOR_SECONDARY = Color(0xFF3E4E70);

  static const Color COLOR_FACEBOOK = Color(0xFF3b5998);
  static const Color COLOR_GOOGLE = Color(0xFFd34836);

  static const Color COLOR_DANGER = Colors.redAccent;
  static const Color COLOR_INFO = Colors.lightBlueAccent;
  static const Color COLOR_WARNING = Color(0xFFFF8F00);
  static const Color COLOR_COOL = Colors.lightGreenAccent;

  static const Color COLOR_TEXT = Color(0xFF111E23);
  static const Color COLOR_TITLE = Color(0xFFC1B560);

  static const Color COLOR_TOP = Color(0xFFC1B560);
  static const Color COLOR_BOTTOM = Color(0xFF15274B);

  static const double minOrder = 50;

  static const String TERMS_AND_CONDITIONS_URL = 'https://www.google.com';

  // static const kGoogleApiKey = "AIzaSyCYl1Yx_g2jss0gxzuyZypP4d3paV6tW4Q";
  static const kGoogleApiKey = "";
  static const kStripeApiKey = ""; // test public key


  static LinearGradient BACKGROUND_GRADIAN = LinearGradient(colors: [
    Constants.COLOR_PRIMARY.withOpacity(0.4),
    Constants.COLOR_SECONDARY.withOpacity(0.4),
  ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

  //colors
  static List<Color> kitGradients = [
    Colors.blueGrey.shade800,
    Colors.black87,
  ];

  static List<Color> kitGradients2 = [
    Colors.cyan.shade600,
    Colors.blue.shade900
  ];

  static List<Color> kitGradients3 = [
    Colors.purple.shade600,
    Colors.deepPurple.shade900
  ];

  static const List<Color> GRADIENT_CHOICES = [COLOR_PRIMARY, COLOR_SECONDARY];

  // Shared Prefs Tags
  static const String EVENT_MODEL = "EVENT_MODEL";
}
