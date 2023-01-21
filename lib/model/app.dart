class App {
  String? android;
  String? ios;
  String? id;
  String? icon;
  String? name;
  int? points;

  App({this.android, this.ios, this.id, this.icon, this.name, this.points});

  App.fromJson(Map<String, dynamic> json) {
    android = json['android'];
    ios = json['ios'];
    id = json['id'];
    icon = json['icon'];
    name = json['name'];
    points = json['points'];
  }

  App.fromDoc(doc) {
    android = doc['android'];
    ios = doc['ios'];
    id = doc['id'];
    icon = doc['icon'];
    name = doc['name'];
    points = doc['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['android'] = android;
    data['ios'] = ios;
    data['id'] = id;
    data['icon'] = icon;
    data['name'] = name;
    data['points'] = points;
    return data;
  }
}