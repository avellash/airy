import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../lib/models/city_model.dart';
import '../lib/services/open_meteo_service.dart';

void main() {
  const testCity = CityModel(
    name: 'Samarinda',
    latitude: -0.5022,
    longitude: 117.1536,
  );

  group('OpenMeteoService Test', () {
    test('Berhasil mengambil data kualitas udara', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'current': {
              'time': '2026-11-03T08:00',
              'us_aqi': 45,
              'pm2_5': 12.5,
              'pm10': 20.0,
            },
            'hourly': {
              'time': ['2026-11-03T08:00'],
              'us_aqi': [45],
              'pm2_5': [12.5],
              'pm10': [20.0],
            },
          }),
          200,
        );
      });

      final service = OpenMeteoService(client: mockClient);

      final result = await service.getAirQuality(testCity);

      expect(result['current'], isNotNull);
      expect(result['hourly'], isNotNull);
      expect(result['current']['us_aqi'], 45);

      service.dispose();
    });

    test('Mengirim koordinat kota dengan benar', () async {
      late Uri requestedUri;

      final mockClient = MockClient((request) async {
        requestedUri = request.url;

        return http.Response(
          jsonEncode({'current': {}, 'hourly': {}}),
          200,
        );
      });

      final service = OpenMeteoService(client: mockClient);

      await service.getAirQuality(testCity);

      expect(
        requestedUri.queryParameters['latitude'],
        '-0.5022',
      );

      expect(
        requestedUri.queryParameters['longitude'],
        '117.1536',
      );

      expect(
        requestedUri.queryParameters['forecast_days'],
        '5',
      );

      expect(
        requestedUri.queryParameters['timezone'],
        'auto',
      );

      expect(
        requestedUri.queryParameters['current'],
        contains('us_aqi'),
      );

      expect(
        requestedUri.queryParameters['hourly'],
        contains('pm2_5'),
      );

      service.dispose();
    });

    test('Menangani HTTP error', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Error', 500);
      });

      final service = OpenMeteoService(client: mockClient);

      expect(
            () => service.getAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains('Kode HTTP: 500'),
          ),
        ),
      );

      service.dispose();
    });

    test('Menangani JSON tidak valid', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Bukan JSON', 200);
      });

      final service = OpenMeteoService(client: mockClient);

      expect(
            () => service.getAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Format data dari server tidak valid.',
            ),
          ),
        ),
      );

      service.dispose();
    });

    test('Menangani error dari API Open-Meteo', () async {
      final mockClient = MockClient((request) async {
        return http.Response(
          jsonEncode({
            'error': true,
            'reason': 'Koordinat tidak valid',
          }),
          200,
        );
      });

      final service = OpenMeteoService(client: mockClient);

      expect(
            () => service.getAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Koordinat tidak valid',
            ),
          ),
        ),
      );

      service.dispose();
    });

    test('Menangani koneksi yang gagal', () async {
      final mockClient = MockClient((request) async {
        throw http.ClientException('Connection failed');
      });

      final service = OpenMeteoService(client: mockClient);

      expect(
            () => service.getAirQuality(testCity),
        throwsA(
          predicate(
                (error) => error.toString().contains(
              'Tidak dapat terhubung ke server.',
            ),
          ),
        ),
      );

      service.dispose();
    });
  });
}
