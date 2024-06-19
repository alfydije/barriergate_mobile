class RiwayatParkir {
  final String tanggal;
  final String nama;
  final String waktuMasuk;
  final String waktuKeluar;

  RiwayatParkir({
    required this.tanggal,
    required this.waktuMasuk,
    required this.waktuKeluar,
    required this.nama,
  });

  factory RiwayatParkir.fromJson(Map<String, dynamic> json) {
    return RiwayatParkir(
      tanggal: json['date'] ?? '',
      waktuMasuk: json['time_in'] ?? '',
      waktuKeluar: json['time_out'] ?? '',
      nama: json['name'] ?? '',
    );
  }
}
