
import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../models/air_quality_model.dart';
import '../models/air_quality_forecast_model.dart';
import '../repositories/air_quality_repository.dart';
import '../services/open_meteo_service.dart';

enum AirQualityStatus {
  initial,
  loading,
  success,
  error,
}

class AirQualityViewModel extends ChangeNotifier {
  // Daftar kota yang tersedia.
  final List<CityModel> cities = const [
    CityModel(name: 'Jakarta', latitude: -6.20, longitude: 106.85),
    CityModel(name: 'Bandung', latitude: -6.91, longitude: 107.61),
    CityModel(name: 'Yogyakarta', latitude: -7.80, longitude: 110.37),
    CityModel(name: 'Surabaya', latitude: -7.25, longitude: 112.75),
    CityModel(name: 'Denpasar', latitude: -8.65, longitude: 115.22),
    CityModel(name: 'Samarinda', latitude: -0.50, longitude: 117.15),
    CityModel(name: 'Makassar', latitude: -5.15, longitude: 119.43),
    CityModel(name: 'Medan', latitude: 3.59, longitude: 98.67),
  ];

  // Kota default.
  CityModel _selectedCity = const CityModel(
    name: 'Samarinda',
    latitude: -0.50,
    longitude: 117.15,
  );

  CityModel get selectedCity => _selectedCity;

  // Service dan Repository.
  late final OpenMeteoService _service;
  late final AirQualityRepository _repository;

  // Data kualitas udara saat ini.
  AirQualityModel? _currentAirQuality;

  AirQualityModel? get currentAirQuality => _currentAirQuality;

  // Data perkiraan kualitas udara.
  AirQualityForecastModel? _forecast;

  AirQualityForecastModel? get forecast => _forecast;

  // Status pengambilan data.
  AirQualityStatus _status = AirQualityStatus.initial;

  AirQualityStatus get status => _status;

  // Pesan error.
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // ID request terbaru.
  int _requestId = 0;

  // Data riwayat SQLite.
  List<Map<String, dynamic>> _history = [];

  List<Map<String, dynamic>> get history => _history;

  bool _isHistoryLoading = false;

  bool get isHistoryLoading => _isHistoryLoading;

  String? _historyError;

  String? get historyError => _historyError;

  // Constructor.
  AirQualityViewModel({
    OpenMeteoService? service,
  }) {
    _service = service ?? OpenMeteoService();

    _repository = AirQualityRepository(
      service: _service,
    );
  }

  // Mengambil data kualitas udara.
  Future<void> loadAirQuality() async {
    final currentRequest = ++_requestId;
    final city = _selectedCity;

    _status = AirQualityStatus.loading;
    _errorMessage = null;

    notifyListeners();

    try {
      final result = await _repository.getCompleteAirQuality(
        city,
      );

      if (currentRequest != _requestId) return;

      _currentAirQuality = result.current;
      _forecast = result.forecast;

      _status = AirQualityStatus.success;

      // Memperbarui riwayat setelah penyimpanan berhasil.
      await loadHistory(cityName: city.name);
    } catch (error) {
      if (currentRequest != _requestId) return;

      _status = AirQualityStatus.error;

      _errorMessage = error.toString().replaceFirst(
        'Exception: ',
        '',
      );
    }

    if (currentRequest == _requestId) {
      notifyListeners();
    }
  }

  // Mengganti kota.
  Future<void> selectCity(CityModel city) async {
    if (_selectedCity.name == city.name) return;

    _selectedCity = city;

    await loadAirQuality();
  }

  // Refresh data.
  Future<void> refreshAirQuality() async {
    await loadAirQuality();
  }

  // Mengambil riwayat dari SQLite.
  Future<void> loadHistory({String? cityName}) async {
    _isHistoryLoading = true;
    _historyError = null;

    notifyListeners();

    try {
      final result = await _repository.getHistory(
        cityName: cityName,
      );

      _history = result;
    } catch (error) {
      _historyError = error.toString();
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }

  // Menghapus satu riwayat.
  Future<void> deleteHistory(int id) async {
    try {
      await _repository.deleteHistory(id);

      await loadHistory();
    } catch (error) {
      _historyError = error.toString();
      notifyListeners();
    }
  }

  // Menghapus semua riwayat.
  Future<void> clearHistory() async {
    try {
      await _repository.clearHistory();

      await loadHistory();
    } catch (error) {
      _historyError = error.toString();
      notifyListeners();
    }
  }

  // Memeriksa kota yang sedang dipilih.
  bool isSelectedCity(CityModel city) {
    return _selectedCity.name == city.name;
  }

  @override
  void dispose() {
    _requestId++;
    _service.dispose();
    super.dispose();
  }
}
