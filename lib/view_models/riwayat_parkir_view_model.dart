import 'package:flutter/material.dart';
import '../../models/riwayat_parkir.dart';
import '../../services/riwayat_parkir_service.dart';

class RiwayatParkirViewModel extends ChangeNotifier {
  final RiwayatParkirService _riwayatParkirService = RiwayatParkirService();
  List<RiwayatParkir> _riwayatParkirList = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<RiwayatParkir> get riwayatParkirList => _riwayatParkirList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  RiwayatParkirViewModel() {
    fetchRiwayatParkir();
  }

  Future<void> fetchRiwayatParkir() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _riwayatParkirList = await _riwayatParkirService.fetchRiwayatParkir();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
