import 'package:flutter/material.dart';
import 'package:ta_mobile/models/user_model.dart';
import '../../services/profil_service.dart';

class ProfilViewModel extends ChangeNotifier {
  late User _user;
  final ProfileService _userService = ProfileService();
  bool _isLoading = false;
  String? _errorMessage;

  User get profile => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProfilViewModel() {
    fetchProfile();
  }

  get user => null;

  Future<void> fetchProfile() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _userService.fetchProfile();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
