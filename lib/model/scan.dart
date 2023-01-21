import 'package:cloud_firestore/cloud_firestore.dart';

class Scan {
  String? id;
  String? owner;
  String? text;
  String? type; // generated / scan
  bool? isLink, isVCard, isWifi, isSMS;
  bool? visible;
  bool? isFav;
  Timestamp? created;

  Scan({this.id, this.owner, this.text, this.isLink, this.isVCard, this.isWifi, this.isSMS, this.isFav, this.type, this.created, this.visible});

  Scan.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['owner'];
    text = json['text'];
    isLink = json['isLink'];
    isVCard = json['isVCard'];
    isWifi = json['isWifi'];
    isSMS = json['isSMS'];
    isFav = json['isFav'];
    type = json['type'];
    created = json['created'];
    visible = json['visible'];
  }

  Scan.fromDoc(doc) {
    id = doc['id'];
    owner = doc['owner'];
    text = doc['text'];
    isLink = doc['isLink'];
    isVCard = doc['isVCard'];
    isWifi = doc['isWifi'];
    isSMS = doc['isSMS'];
    isFav = doc['isFav'];
    type = doc['type'];
    created = doc['created'];
    visible = doc['visible'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['owner'] = owner;
    data['text'] = text;
    data['isLink'] = isLink;
    data['isVCard'] = isVCard;
    data['isWifi'] = isWifi;
    data['isSMS'] = isSMS;
    data['isFav'] = isFav;
    data['type'] = type;
    data['created'] = created;
    data['visible'] = visible;
    return data;
  }
}