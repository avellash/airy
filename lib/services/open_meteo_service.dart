import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city_model.dart';

class OpenMeteoService {
  static const String _baseUrl =
      'https://air-quality-api.open-meteo.com/v1/air-quality';

  // HTTP client dapat diganti dengan MockClient saat pengujian.
  final http.Client client;

  OpenMeteoService({
    http.Client? client,
  }) : client = client ?? http.Client();

  // Mengambil data kualitas udara berdasarkan koordinat kota.
  Future<Map<String, dynamic>> getAirQuality(
      CityModel city,
      ) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'latitude': city.latitude.toString(),
        'longitude': city.longitude.toString(),

        // Data kualitas udara saat ini.
        'current': [
          'us_aqi',
          'pm2_5',
          'pm10',
          'carbon_monoxide',
          'nitrogen_dioxide',
          'sulphur_dioxide',
          'ozone',
        ].join(','),

        // Data perkiraan kualitas udara per jam.
        'hourly': [
          'us_aqi',
          'pm2_5',
          'pm10',
        ].join(','),

        'forecast_days': '5',
        'timezone': 'auto',
      },
    );

    try {
      final response = await client
          .get(uri)
          .timeout(const Duration(seconds: 20));

      // Memeriksa status HTTP.
      if (response.statusCode != 200) {
        throw Exception(
          'Gagal mengambil data kualitas udara. '
              'Kode HTTP: ${response.statusCode}',
        );
      }

      // Mengubah respons JSON menjadi Map.
      final Map<String, dynamic> data =
      jsonDecode(response.body) as Map<String, dynamic>;

      // Memeriksa apakah API mengembalikan error.
      if (data['error'] == true) {
        throw Exception(
          data['reason'] ?? 'Terjadi kesalahan pada API.',
        );
      }

      return data;
    } on TimeoutException {
      throw Exception(
        'Koneksi terlalu lama. Silakan coba lagi.',
      );
    } on http.ClientException {
      throw Exception(
        'Tidak dapat terhubung ke server. '
            'Periksa koneksi internet.',
      );
    } on FormatException {
      throw Exception(
        'Format data dari server tidak valid.',
      );
    }
  }

  // Menutup HTTP client ketika tidak digunakan.
  void dispose() {
    client.close();
  }
}
