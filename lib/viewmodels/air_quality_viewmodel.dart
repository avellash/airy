import 'package:flutter/material.dart';

import '../models/city_model.dart';
import '../models/air_quality_model.dart';
import '../models/air_quality_forecast_model.dart';
import '../repositories/air_quality_repository.dart';
import '../services/open_meteo_service.dart';

// Status proses pengambilan data.
enum AirQualityStatus {
  initial,
  loading,
  success,
  error,
}

class AirQualityViewModel extends ChangeNotifier {
  // Daftar kota yang tersedia dalam aplikasi.
  final List<CityModel> cities = const [
    CityModel(
      name: 'Jakarta',
      latitude: -6.20,
      longitude: 106.85,
    ),
    CityModel(
      name: 'Bandung',
      latitude: -6.91,
      longitude: 107.61,
    ),
    CityModel(
      name: 'Yogyakarta',
      latitude: -7.80,
      longitude: 110.37,
    ),
    CityModel(
      name: 'Surabaya',
      latitude: -7.25,
      longitude: 112.75,
    ),
    CityModel(
      name: 'Denpasar',
      latitude: -8.65,
      longitude: 115.22,
    ),
    CityModel(
      name: 'Samarinda',
      latitude: -0.50,
      longitude: 117.15,
    ),
    CityModel(
      name: 'Makassar',
      latitude: -5.15,
      longitude: 119.43,
    ),
    CityModel(
      name: 'Medan',
      latitude: 3.59,
      longitude: 98.67,
    ),
  ];

  // Kota yang pertama kali ditampilkan.
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

  // Pesan error jika pengambilan data gagal.
  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  // Memastikan request terbaru yang mengubah tampilan.
  int _requestId = 0;

  // Constructor untuk menginisialisasi Service dan Repository.
  AirQualityViewModel({
    OpenMeteoService? service,
  }) {
    _service = service ?? OpenMeteoService();

    _repository = AirQualityRepository(
      service: _service,
    );
  }

  // Mengambil data kualitas udara berdasarkan kota terpilih.
  Future<void> loadAirQuality() async {
    final currentRequest = ++_requestId;
    final city = _selectedCity;

    _status = AirQualityStatus.loading;
    _errorMessage = null;

    notifyListeners();

    try {
      // Mengambil data current dan forecast sekaligus.
      final result = await _repository.getCompleteAirQuality(
        city,
      );

      // Mengabaikan hasil request yang sudah tidak terbaru.
      if (currentRequest != _requestId) return;

      _currentAirQuality = result.current;
      _forecast = result.forecast;

      _status = AirQualityStatus.success;
      _errorMessage = null;
    } catch (error) {
      // Mengabaikan error dari request yang sudah tidak terbaru.
      if (currentRequest != _requestId) return;

      _status = AirQualityStatus.error;
      _errorMessage = error.toString().replaceFirst(
        'Exception: ',
        '',
      );
    }

    notifyListeners();
  }

  // Mengganti kota yang sedang dipilih.
  Future<void> selectCity(CityModel city) async {
    if (_selectedCity.name == city.name) return;

    _selectedCity = city;

    await loadAirQuality();
  }

  // Memperbarui data ketika pengguna melakukan refresh.
  Future<void> refreshAirQuality() async {
    await loadAirQuality();
  }

  // Memeriksa apakah kota sedang dipilih.
  bool isSelectedCity(CityModel city) {
    return _selectedCity.name == city.name;
  }

  // Menutup koneksi ketika ViewModel tidak digunakan.
  @override
  void dispose() {
    _requestId++;
    _service.dispose();
    super.dispose();
  }
}
