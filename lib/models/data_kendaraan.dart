class DataKendaraan {
  final String merk;
  final String gambar;
  final String tipe;
  final String noKendaraan;

  DataKendaraan({
    required this.merk,
    required this.gambar,
    required this.tipe,
    required this.noKendaraan,
  });

  factory DataKendaraan.fromJson(Map<String, dynamic> json){
    return DataKendaraan(
      merk: json['brand'],
      gambar: json['image'],
      tipe: json['type'],
      noKendaraan: json ['vehicle_number'],
    );
  }
}