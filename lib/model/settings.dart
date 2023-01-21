// ignore_for_file: non_constant_identifier_names

class AppSettings {
  String? android_banner_ad_id;
  String? android_interstitial_ad_id;
  String? ios_banner_ad_id;
  String? ios_interstitial_ad_id;
  int? repeat_interstitial;
  int? share_with;
  bool? show_banner;
  bool? show_interstitial;
  bool? show_freeads_offer;

  Map? announcements;

  AppSettings({this.ios_banner_ad_id, this.ios_interstitial_ad_id, this.android_banner_ad_id, this.android_interstitial_ad_id, this.repeat_interstitial,
   this.show_banner, this.show_interstitial, this.show_freeads_offer, this.share_with, this.announcements});

  AppSettings.fromJson(Map<String, dynamic> json) {
    android_banner_ad_id = json['android_banner_ad_id'];
    android_interstitial_ad_id = json['android_interstitial_ad_id'];
    ios_banner_ad_id = json['ios_banner_ad_id'];
    ios_interstitial_ad_id = json['ios_interstitial_ad_id'];
    repeat_interstitial = json['repeat_interstitial'];
    show_banner = json['show_banner'];
    show_interstitial = json['show_interstitial'];
    show_freeads_offer = json['show_freeads_offer'];
    share_with = json['share_with'];
    announcements = json['announcements'];
  }

  AppSettings.fromDoc(doc) {
    android_banner_ad_id = doc['android_banner_ad_id'];
    android_interstitial_ad_id = doc['android_interstitial_ad_id'];
    ios_banner_ad_id = doc['ios_banner_ad_id'];
    ios_interstitial_ad_id = doc['ios_interstitial_ad_id'];
    repeat_interstitial = doc['repeat_interstitial'];
    show_banner = doc['show_banner'];
    show_interstitial = doc['show_interstitial'];
    show_freeads_offer = doc['show_freeads_offer'];
    share_with = doc['share_with'];

    announcements = doc['announcements'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android_banner_ad_id'] = android_banner_ad_id;
    data['android_interstitial_ad_id'] = android_interstitial_ad_id;
    data['ios_banner_ad_id'] = ios_banner_ad_id;
    data['ios_interstitial_ad_id'] = ios_interstitial_ad_id;
    data['repeat_interstitial'] = repeat_interstitial;
    data['show_banner'] = show_banner;
    data['show_interstitial'] = show_interstitial;
    data['show_freeads_offer'] = show_freeads_offer;
    data['share_with'] = share_with;
    data['announcements'] = announcements;
    return data;
  }
}