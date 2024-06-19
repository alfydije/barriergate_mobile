import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

import '../models/data_kendaraan.dart';
class DatakendaraanService{
  final Logger _logger = Logger();

  Future<List<DataKendaraan>> fetchDataKendaraan() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('https://bariergate.my.id/api/data-kendaraan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        List<DataKendaraan> listRiwayatParkir = data
            .map<DataKendaraan>((item) => DataKendaraan.fromJson(item))
            .toList();
        return listRiwayatParkir;
      } else {
        throw Exception(
            'Failed to load parking history. Status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.e('Error fetching parking historyy: $e',
          error: e, stackTrace: stackTrace);
      throw Exception('Failed to load parking history: $e');
    }
  }
}