import 'package:flutter/material.dart';

class AirQualityStatusWidget extends StatelessWidget {
  final num aqi;

  const AirQualityStatusWidget({
    super.key,
    required this.aqi,
  });

  String get category {
    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) return 'Tidak Sehat bagi Kelompok Sensitif';
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Tidak Sehat';
    return 'Berbahaya';
  }

  Color get statusColor {
    if (aqi <= 50) return const Color(0xFF55B98A);
    if (aqi <= 100) return const Color(0xFFE4B64D);
    if (aqi <= 150) return const Color(0xFFE99562);
    if (aqi <= 200) return const Color(0xFFE66B82);
    if (aqi <= 300) return const Color(0xFF9B75C9);
    return const Color(0xFF8B2635);
  }

  String get description {
    if (aqi <= 50) {
      return 'Udara bersih dan baik untuk aktivitas luar ruangan.';
    }
    if (aqi <= 100) {
      return 'Kualitas udara masih dapat diterima.';
    }
    if (aqi <= 150) {
      return 'Kelompok sensitif sebaiknya membatasi aktivitas luar ruangan.';
    }
    if (aqi <= 200) {
      return 'Kurangi aktivitas di luar ruangan.';
    }
    if (aqi <= 300) {
      return 'Hindari aktivitas luar ruangan jika memungkinkan.';
    }
    return 'Hindari paparan udara luar dan gunakan perlindungan.';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: statusColor.withOpacity(0.25),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.air_rounded,
            color: statusColor,
            size: 30,
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
                    color: Color(0xFF625879),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
