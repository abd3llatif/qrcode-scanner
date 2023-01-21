class User {
  String? uid;


  User({this.uid});

  User.fromMap(json) {
    uid = json['id'];
  }
}
