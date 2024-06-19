import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:ta_mobile/models/user_model.dart';

class ProfileService {
  final Logger _logger = Logger();

  Future<User> fetchProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Map<String, dynamic> userData = jsonDecode(prefs.getString("user_data")!);
      return User.fromJson(userData);
      // String? token = prefs.getString('token');

      // if (token == null) {
      //   throw Exception('Token not found');
      // }

      // final response = await http.get(
      //   Uri.parse('https://bariergate.my.id/api/user-profile'),
      //   headers: {
      //     'Authorization': 'Bearer $token',
      //     'Accept': 'application/json'
      //   },
      // );

      // if (response.statusCode == 200) {
      //   var jsonResponse = json.decode(response.body);
      //   var data = jsonResponse['data'];
      //   return Profile.fromJson(data); // Mengembalikan objek Profile tunggal
      // } else {
      //   throw Exception('Failed to load profile. Status code: ${response.statusCode}');
      // }
    } catch (e, stackTrace) {
      _logger.e('Error fetching profile: $e', error: e, stackTrace: stackTrace);
      throw Exception('Failed to load profile: $e');
    }
  }

}
