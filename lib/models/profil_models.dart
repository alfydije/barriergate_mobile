class Profile {
  final String name;
  final String address;
  final String phoneNumber;
  final String nipNim;
  final String image;
  final String gender;
  final String email;
  final String username;

  Profile({
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.nipNim,
    required this.image,
    required this.gender,
    required this.email,
    required this.username,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      nipNim: json['nip_nim'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
    );
  }
}
