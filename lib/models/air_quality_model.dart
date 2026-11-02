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

  // Mengubah data JSON dari API menjadi objek AirQualityModel.
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

  // Memastikan nilai numerik dapat dibaca sebagai double.
  static double? _toDouble(dynamic value) {
    if (value == null) return null;

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(value.toString());
  }
}
