class AirQualityForecastModel {
  final List<AirQualityForecastHour> hourlyForecast;

  const AirQualityForecastModel({
    required this.hourlyForecast,
  });

  // Mengubah data hourly dari API menjadi daftar objek forecast.
  factory AirQualityForecastModel.fromJson(
      Map<String, dynamic> json,
      ) {
    final hourly = json['hourly'] as Map<String, dynamic>? ?? {};

    final times = hourly['time'] as List? ?? [];
    final aqiValues = hourly['us_aqi'] as List? ?? [];
    final pm25Values = hourly['pm2_5'] as List? ?? [];
    final pm10Values = hourly['pm10'] as List? ?? [];

    final forecast = <AirQualityForecastHour>[];

    // Menggunakan panjang data waktu agar indeks tetap aman.
    for (int i = 0; i < times.length; i++) {
      forecast.add(
        AirQualityForecastHour(
          time: times[i]?.toString() ?? '',
          usAqi: _toDouble(
            i < aqiValues.length ? aqiValues[i] : null,
          ),
          pm25: _toDouble(
            i < pm25Values.length ? pm25Values[i] : null,
          ),
          pm10: _toDouble(
            i < pm10Values.length ? pm10Values[i] : null,
          ),
        ),
      );
    }

    return AirQualityForecastModel(
      hourlyForecast: forecast,
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}

// Menampung perkiraan kualitas udara untuk satu waktu.
class AirQualityForecastHour {
  final String time;
  final double? usAqi;
  final double? pm25;
  final double? pm10;

  const AirQualityForecastHour({
    required this.time,
    this.usAqi,
    this.pm25,
    this.pm10,
  });
}
