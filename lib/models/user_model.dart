import 'package:ta_mobile/models/user_profile_model.dart';

class User {
  String? id;
  String? username;
  String? email;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? name;
  UserProfile? userProfile;

  User(
      {this.id,
      this.username,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.userProfile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    userProfile = json['user_profile'] != null
        ? UserProfile?.fromJson(json['user_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['name'] = name;
    if (userProfile != null) {
      data['user_profile'] = userProfile?.toJson();
    }
    return data;
  }
}
