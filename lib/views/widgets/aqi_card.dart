import 'package:flutter/material.dart';

class AqiCard extends StatelessWidget {
  final num aqi;
  final String time;

  const AqiCard({
    super.key,
    required this.aqi,
    required this.time,
  });

  Color get aqiColor {
    if (aqi <= 50) return const Color(0xFF55B98A);
    if (aqi <= 100) return const Color(0xFFE4B64D);
    if (aqi <= 150) return const Color(0xFFE99562);
    if (aqi <= 200) return const Color(0xFFE66B82);
    if (aqi <= 300) return const Color(0xFF9B75C9);
    return const Color(0xFF8B2635);
  }

  String get category {
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) return 'Tidak Sehat bagi Kelompok Sensitif';
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }

  String get formattedTime {
    try {
      final date = DateTime.parse(time).toLocal();
      return '${date.day}/${date.month}/${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(23),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFBCA8F2),
            Color(0xFF9277D8),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9277D8).withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.air_rounded,
                color: Colors.white,
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                'Indeks Kualitas Udara',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aqi.toStringAsFixed(0),
                      style: const TextStyle(
                        fontSize: 65,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 13,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: TextStyle(
                          color: aqiColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_rounded,
                  size: 67,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Container(
            height: 1,
            color: Colors.white.withOpacity(0.3),
          ),

          const SizedBox(height: 13),

          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 7),
              const Text(
                'Pembaruan data: ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                ),
              ),
              Expanded(
                child: Text(
                  formattedTime,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
