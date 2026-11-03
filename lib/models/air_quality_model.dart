
class AirQualityModel {
  final String time;
  final double? usAqi;
  final double? pm25;
  final double? pm10;
  final double? carbonMonoxide;
  final double? nitrogenDioxide;
  final double? sulphurDioxide;
  final double? ozone;

  const AirQualityModel({
    required this.time,
    this.usAqi,
    this.pm25,
    this.pm10,
    this.carbonMonoxide,
    this.nitrogenDioxide,
    this.sulphurDioxide,
    this.ozone,
  });

  // Mengubah JSON API menjadi objek model.
  factory AirQualityModel.fromJson(Map<String, dynamic> json) {
    return AirQualityModel(
      time: json['time']?.toString() ?? '',
      usAqi: _toDouble(json['us_aqi']),
      pm25: _toDouble(json['pm2_5']),
      pm10: _toDouble(json['pm10']),
      carbonMonoxide: _toDouble(json['carbon_monoxide']),
      nitrogenDioxide: _toDouble(json['nitrogen_dioxide']),
      sulphurDioxide: _toDouble(json['sulphur_dioxide']),
      ozone: _toDouble(json['ozone']),
    );
  }

  // Mengubah objek model menjadi Map untuk SQLite.
  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'us_aqi': usAqi,
      'pm25': pm25,
      'pm10': pm10,
      'carbon_monoxide': carbonMonoxide,
      'nitrogen_dioxide': nitrogenDioxide,
      'sulphur_dioxide': sulphurDioxide,
      'ozone': ozone,
    };
  }

  // Mengambil data dari SQLite menjadi objek model.
  factory AirQualityModel.fromMap(Map<String, dynamic> map) {
    return AirQualityModel(
      time: map['time']?.toString() ?? '',
      usAqi: _toDouble(map['us_aqi']),
      pm25: _toDouble(map['pm25']),
      pm10: _toDouble(map['pm10']),
      carbonMonoxide: _toDouble(map['carbon_monoxide']),
      nitrogenDioxide: _toDouble(map['nitrogen_dioxide']),
      sulphurDioxide: _toDouble(map['sulphur_dioxide']),
      ozone: _toDouble(map['ozone']),
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
