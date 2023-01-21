class Offer {
  String? title;
  String? desc;
  String? id;
  int? points;
  bool? canClaim;

  Offer({this.title, this.desc, this.id, this.points, this.canClaim});

  Offer.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    desc = json['desc'];
    id = json['id'];
    canClaim = json['canClaim'];
    points = json['points'];
  }

  Offer.fromDoc(doc) {
    title = doc['title'];
    desc = doc['desc'];
    id = doc['id'];
    canClaim = doc['canClaim'];
    points = doc['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['desc'] = desc;
    data['id'] = id;
    data['canClaim'] = canClaim;
    data['points'] = points;
    return data;
  }
}