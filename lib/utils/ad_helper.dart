import 'dart:io';

import 'package:qrcodescanner/utils/constants.dart';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return Constants.ANDROID_BANNER_AD_ID;
    } else if (Platform.isIOS) {
      return Constants.IOS_BANNER_AD_ID;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return Constants.ANDROID_INTERSTITIAL_AD_ID;
    } else if (Platform.isIOS) {
      return Constants.IOS_INTERSTITIAL_AD_ID;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return Constants.ANDROID_INTERSTITIAL_AD_ID;
    } else if (Platform.isIOS) {
      return Constants.IOS_INTERSTITIAL_AD_ID;
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}