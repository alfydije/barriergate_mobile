class UserProfile {
  String? id;
  String? userId;
  String? name;
  String? address;
  String? phoneNumber;
  String? nipNim;
  String? image;
  String? cardId;
  String? gender;
  String? createdAt;
  String? updatedAt;

  UserProfile(
      {this.id,
      this.userId,
      this.name,
      this.address,
      this.phoneNumber,
      this.nipNim,
      this.image,
      this.cardId,
      this.gender,
      this.createdAt,
      this.updatedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    address = json['address'];
    phoneNumber = json['phone_number'];
    nipNim = json['nip_nim'];
    image = json['image'];
    cardId = json['card_id'];
    gender = json['gender'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['address'] = address;
    data['phone_number'] = phoneNumber;
    data['nip_nim'] = nipNim;
    data['image'] = image;
    data['card_id'] = cardId;
    data['gender'] = gender;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
