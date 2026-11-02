
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../lib/models/city_model.dart';
import '../lib/repositories/air_quality_repository.dart';
import '../lib/services/open_meteo_service.dart';

void main() {
  const testCity = CityModel(
    name: 'Samarinda',
    latitude: -0.5022,
    longitude: 117.1536,
  );

  final testData = {
    'current': {
      'time': '2026-11-03T08:00',
      'us_aqi': 45,
      'pm2_5': 12.5,
      'pm10': 20.0,
      'carbon_monoxide': 200.0,
      'nitrogen_dioxide': 10.0,
      'sulphur_dioxide': 5.0,
      'ozone': 30.0,
    },
    'hourly': {
      'time': [
        '2026-11-03T08:00',
        '2026-11-03T09:00',
      ],
      'us_aqi': [45, 50],
      'pm2_5': [12.5, 14.0],
      'pm10': [20.0, 22.0],
    },
  };

  // Membuat repository dengan HTTP client tiruan.
  AirQualityRepository createRepository(
      Map<String, dynamic> responseData,
      ) {
    final mockClient = MockClient((request) async {
      return http.Response(
        jsonEncode(responseData),
        200,
      );
    });

    final service = OpenMeteoService(
      client: mockClient,
    );

    return AirQualityRepository(service: service);
  }

  group('AirQualityRepository Test', () {
    test('Berhasil mengambil data kualitas udara saat ini', () async {
      final repository = createRepository(testData);

      final result = await repository.getCurrentAirQuality(
        testCity,
      );

      expect(result.time, '2026-11-03T08:00');
      expect(result.usAqi, 45.0);
      expect(result.pm25, 12.5);
      expect(result.pm10, 20.0);
      expect(result.carbonMonoxide, 200.0);
      expect(result.nitrogenDioxide, 10.0);
      expect(result.sulphurDioxide, 5.0);
      expect(result.ozone, 30.0);
    });

    test('Berhasil mengambil data perkiraan kualitas udara', () async {
      final repository = createRepository(testData);

      final result = await repository.getAirQualityForecast(
        testCity,
      );

      expect(result.hourlyForecast.length, 2);

      expect(
        result.hourlyForecast[0].time,
        '2026-11-03T08:00',
      );

      expect(
        result.hourlyForecast[0].usAqi,
        45.0,
      );

      expect(
        result.hourlyForecast[0].pm25,
        12.5,
      );

      expect(
        result.hourlyForecast[0].pm10,
        20.0,
      );
    });

    test('Berhasil mengambil data lengkap dalam satu hasil', () async {
      final repository = createRepository(testData);

      final result = await repository.getCompleteAirQuality(
        testCity,
      );

      expect(result.current.usAqi, 45.0);
      expect(result.current.pm25, 12.5);

      expect(
        result.forecast.hourlyForecast.length,
        2,
      );

      expect(
        result.forecast.hourlyForecast[1].usAqi,
        50.0,
      );
    });

    test('Gagal jika data current tidak tersedia', () async {
      final repository = createRepository({
        'hourly': testData['hourly'],
      });

      expect(
            () => repository.getCurrentAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Data kualitas udara saat ini tidak tersedia.',
            ),
          ),
        ),
      );
    });

    test('Gagal jika data hourly tidak tersedia', () async {
      final repository = createRepository({
        'current': testData['current'],
      });

      expect(
            () => repository.getAirQualityForecast(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Data perkiraan kualitas udara tidak tersedia.',
            ),
          ),
        ),
      );
    });

    test('Gagal jika data lengkap tidak tersedia', () async {
      final repository = createRepository({
        'current': testData['current'],
      });

      expect(
            () => repository.getCompleteAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Data kualitas udara dari server tidak lengkap.',
            ),
          ),
        ),
      );
    });
  });
}
