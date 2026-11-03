
import '../models/air_quality_model.dart';
import '../models/air_quality_forecast_model.dart';
import '../models/city_model.dart';
import '../services/open_meteo_service.dart';
import '../services/database_service.dart';

class AirQualityRepository {
  final OpenMeteoService service;
  final DatabaseService databaseService;

  AirQualityRepository({
    required this.service,
    DatabaseService? databaseService,
  }) : databaseService =
      databaseService ?? DatabaseService.instance;

  // Mengambil data kualitas udara saat ini.
  // Data otomatis disimpan ke SQLite.
  Future<AirQualityModel> getCurrentAirQuality(
      CityModel city,
      ) async {
    final data = await service.getAirQuality(city);

    final currentData =
    data['current'] as Map<String, dynamic>?;

    if (currentData == null) {
      throw Exception(
        'Data kualitas udara saat ini tidak tersedia.',
      );
    }

    final airQuality =
    AirQualityModel.fromJson(currentData);

    await databaseService.saveAirQuality(
      city.name,
      airQuality,
    );

    return airQuality;
  }

  // Mengambil perkiraan kualitas udara per jam.
  Future<AirQualityForecastModel> getAirQualityForecast(
      CityModel city,
      ) async {
    final data = await service.getAirQuality(city);

    if (data['hourly'] == null) {
      throw Exception(
        'Data perkiraan kualitas udara tidak tersedia.',
      );
    }

    return AirQualityForecastModel.fromJson(data);
  }

  // Mengambil data saat ini dan forecast dalam satu request.
  // Data saat ini otomatis disimpan ke SQLite.
  Future<AirQualityData> getCompleteAirQuality(
      CityModel city,
      ) async {
    final data = await service.getAirQuality(city);

    final currentData =
    data['current'] as Map<String, dynamic>?;

    if (currentData == null || data['hourly'] == null) {
      throw Exception(
        'Data kualitas udara dari server tidak lengkap.',
      );
    }

    final current =
    AirQualityModel.fromJson(currentData);

    final forecast =
    AirQualityForecastModel.fromJson(data);

    await databaseService.saveAirQuality(
      city.name,
      current,
    );

    return AirQualityData(
      current: current,
      forecast: forecast,
    );
  }

  // Mengambil riwayat kualitas udara.
  Future<List<Map<String, dynamic>>> getHistory({
    String? cityName,
  }) {
    return databaseService.getHistory(
      cityName: cityName,
    );
  }

  // Menghapus satu riwayat.
  Future<void> deleteHistory(int id) async {
    await databaseService.deleteHistory(id);
  }

  // Menghapus seluruh riwayat.
  Future<void> clearHistory() async {
    await databaseService.clearHistory();
  }
}

// Menggabungkan data saat ini dan perkiraan.
class AirQualityData {
  final AirQualityModel current;
  final AirQualityForecastModel forecast;

  const AirQualityData({
    required this.current,
    required this.forecast,
  });
}
