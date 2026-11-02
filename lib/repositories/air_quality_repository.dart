import '../models/air_quality_model.dart';
import '../models/air_quality_forecast_model.dart';
import '../models/city_model.dart';
import '../services/open_meteo_service.dart';

class AirQualityRepository {
  final OpenMeteoService service;

  AirQualityRepository({
    required this.service,
  });

  // Mengambil data kualitas udara dan mengubahnya menjadi Model.
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

    return AirQualityModel.fromJson(currentData);
  }

  // Mengambil data perkiraan kualitas udara per jam.
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

    return AirQualityData(
      current: AirQualityModel.fromJson(currentData),
      forecast: AirQualityForecastModel.fromJson(data),
    );
  }
}

// Menggabungkan data saat ini dan data perkiraan.
class AirQualityData {
  final AirQualityModel current;
  final AirQualityForecastModel forecast;

  const AirQualityData({
    required this.current,
    required this.forecast,
  });
}
