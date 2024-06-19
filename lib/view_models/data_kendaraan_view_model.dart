import 'package:flutter/material.dart';
import '../models/data_kendaraan.dart';
import '../services/data_kendaraan_service.dart';

class DataKendaraanViewModel extends ChangeNotifier {
  final DatakendaraanService _service = DatakendaraanService();
  List<DataKendaraan> _dataKendaraan = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DataKendaraan> get dataKendaraan => _dataKendaraan;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dataKendaraan = await _service.fetchDataKendaraan();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
