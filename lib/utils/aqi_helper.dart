import 'package:flutter/material.dart';

class AqiHelper {
  // Mengubah nilai AQI menjadi kategori Bahasa Indonesia.
  static String getCategory(double? aqi) {
    if (aqi == null) return 'Tidak Tersedia';

    if (aqi <= 50) return 'Baik';
    if (aqi <= 100) return 'Sedang';
    if (aqi <= 150) {
      return 'Tidak Sehat bagi Kelompok Sensitif';
    }
    if (aqi <= 200) return 'Tidak Sehat';
    if (aqi <= 300) return 'Sangat Tidak Sehat';

    return 'Berbahaya';
  }

  // Menentukan warna berdasarkan kategori AQI.
  static Color getColor(double? aqi) {
    if (aqi == null) return const Color(0xFFB8B4C9);

    if (aqi <= 50) return const Color(0xFF65BFA0);
    if (aqi <= 100) return const Color(0xFFF0C66A);
    if (aqi <= 150) return const Color(0xFFE99B75);
    if (aqi <= 200) return const Color(0xFFE77F91);
    if (aqi <= 300) return const Color(0xFF9D82D8);

    return const Color(0xFF8B506F);
  }

  // Memberikan penjelasan kondisi udara dalam Bahasa Indonesia.
  static String getDescription(double? aqi) {
    if (aqi == null) {
      return 'Informasi kualitas udara saat ini belum tersedia.';
    }

    if (aqi <= 50) {
      return 'Kualitas udara tergolong baik. '
          'Aktivitas di luar ruangan dapat dilakukan dengan nyaman.';
    }

    if (aqi <= 100) {
      return 'Kualitas udara masih dapat diterima. '
          'Kelompok sensitif sebaiknya tetap memperhatikan kondisi kesehatan.';
    }

    if (aqi <= 150) {
      return 'Kelompok sensitif berisiko mengalami gangguan kesehatan. '
          'Sebaiknya kurangi aktivitas berat di luar ruangan.';
    }

    if (aqi <= 200) {
      return 'Kualitas udara tidak sehat. '
          'Masyarakat disarankan mengurangi aktivitas di luar ruangan.';
    }

    if (aqi <= 300) {
      return 'Kualitas udara sangat tidak sehat. '
          'Batasi aktivitas di luar ruangan dan lindungi kesehatan.';
    }

    return 'Kualitas udara berbahaya. '
        'Hindari aktivitas di luar ruangan dan tetap berada di dalam ruangan.';
  }

  // Membulatkan nilai AQI untuk ditampilkan.
  static String formatAqi(double? aqi) {
    if (aqi == null) return '--';

    return aqi.round().toString();
  }
}
