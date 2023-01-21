class Profile {
  String? fullName;
  String? phone;
  String? email;
  String? id;
  String? fcm;
  String? referral;
  bool? isPro;
  bool? isAdmin;
  int? sharedWith;
  int? points;

  Profile({this.fullName, this.phone, this.email, this.id, this.fcm, this.isPro, this.isAdmin, this.referral, this.sharedWith, this.points});

  Profile.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    phone = json['phone'];
    email = json['email'];
    id = json['id'];
    fcm = json['fcm'];
    isPro = json['isPro'];
    isAdmin = json['isAdmin'];
    referral = json['referral'];
    sharedWith = json['sharedWith'];
    points = json['points'];
  }

  Profile.fromDoc(doc) {
    fullName = doc['fullName'];
    phone = doc['phone'];
    email = doc['email'];
    id = doc['id'];
    fcm = doc['fcm'];
    isPro = doc['isPro'];
    isAdmin = doc['isAdmin'];
    referral = doc['referral'];
    sharedWith = doc['sharedWith'];
    points = doc['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['phone'] = phone;
    data['email'] = email;
    data['id'] = id;
    data['fcm'] = fcm;
    data['isPro'] = isPro;
    data['isAdmin'] = isAdmin;
    data['referral'] = referral;
    data['sharedWith'] = sharedWith;
    data['points'] = points;

    return data;
  }
}