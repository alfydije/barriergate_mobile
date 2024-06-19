// ignore_for_file: avoid_print

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import '../models/riwayat_parkir.dart';

class RiwayatParkirService {
  final Logger _logger = Logger();

  Future<List<RiwayatParkir>> fetchRiwayatParkir() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final response = await http.get(
        Uri.parse('https://bariergate.my.id/api/riwayat-parkir'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        List<dynamic> data = jsonResponse['data'];
        List<RiwayatParkir> listRiwayatParkir = data
            .map<RiwayatParkir>((item) => RiwayatParkir.fromJson(item))
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
