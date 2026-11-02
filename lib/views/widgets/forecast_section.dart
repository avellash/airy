import 'package:flutter/material.dart';

class ForecastSection extends StatelessWidget {
  final dynamic forecast;

  const ForecastSection({
    super.key,
    required this.forecast,
  });

  Color _getColor(num aqi) {
    if (aqi <= 50) return const Color(0xFF55B98A);
    if (aqi <= 100) return const Color(0xFFE4B64D);
    if (aqi <= 150) return const Color(0xFFE99562);
    if (aqi <= 200) return const Color(0xFFE66B82);
    if (aqi <= 300) return const Color(0xFF9B75C9);
    return const Color(0xFF8B2635);
  }

  String _getCategory(num aqi) {
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) return 'Kurang Baik';
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Buruk';
    return 'Berbahaya';
  }

  String _getHour(String time) {
    try {
      final date = DateTime.parse(time).toLocal();
      return '${date.hour.toString().padLeft(2, '0')}:00';
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> hours = forecast.hourlyForecast;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prakiraan Kualitas Udara',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF30294A),
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Perkiraan perubahan kualitas udara beberapa jam ke depan.',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF89839D),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          height: 165,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: hours.length > 12 ? 12 : hours.length,
            itemBuilder: (context, index) {
              final item = hours[index];
              final num aqi = item.usAqi;

              return Container(
                width: 105,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(19),
                  border: Border.all(
                    color: const Color(0xFFEDE7FA),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getHour(item.time),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF625879),
                      ),
                    ),

                    Icon(
                      Icons.air_rounded,
                      size: 28,
                      color: _getColor(aqi),
                    ),

                    Text(
                      aqi.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40345F),
                      ),
                    ),

                    Text(
                      _getCategory(aqi),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getColor(aqi),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 15),

        // Keterangan satuan AQI.
        const Text(
          'AQI (Air Quality Index) merupakan indeks '
              'untuk menunjukkan tingkat kualitas udara. '
              'Semakin tinggi nilainya, semakin buruk kualitas udara.',
          style: TextStyle(
            fontSize: 11,
            height: 1.5,
            color: Color(0xFF89839D),
          ),
        ),
      ],
    );
  }
}
