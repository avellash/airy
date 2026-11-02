
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/air_quality_viewmodel.dart';

import 'widgets/city_selector.dart';
import 'widgets/aqi_card.dart';
import 'widgets/pollutant_card.dart';
import 'widgets/forecast_section.dart';
import 'widgets/air_quality_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    // Memuat data kualitas udara saat homepage pertama kali dibuka.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AirQualityViewModel>().loadAirQuality();
    });
  }

  // Memperbarui data kualitas udara.
  Future<void> _refreshData() async {
    await context.read<AirQualityViewModel>().refreshAirQuality();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AirQualityViewModel>(
      builder: (context, viewModel, child) {
        final current = viewModel.currentAirQuality;
        final forecast = viewModel.forecast;

        final isLoading =
            viewModel.status == AirQualityStatus.loading;

        final hasError =
            viewModel.status == AirQualityStatus.error;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F6FF),

          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xFF9277D8),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Airy',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF40345F),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Pantau kualitas udara di sekitarmu',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE7FA),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.air_rounded,
                            size: 27,
                            color: Color(0xFF9277D8),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // JUDUL HALAMAN
                    const Text(
                      'Kualitas Udara',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF40345F),
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Ketahui kondisi udara dan lindungi kesehatanmu.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // PILIH KOTA
                    const Text(
                      'Pilih Lokasi',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF40345F),
                      ),
                    ),

                    const SizedBox(height: 10),

                    CitySelector(
                      cities: viewModel.cities,
                      selectedCity: viewModel.selectedCity,
                      onChanged: (city) {
                        viewModel.selectCity(city);
                      },
                    ),

                    const SizedBox(height: 24),

                    // KONDISI LOADING
                    if (isLoading && current == null)
                      _buildLoading(),

                    // KONDISI ERROR
                    if (hasError && current == null)
                      _buildError(
                        viewModel.errorMessage ??
                            'Gagal mengambil data kualitas udara.',
                      ),

                    // DATA KUALITAS UDARA
                    if (current != null) ...[
                      // STATUS KUALITAS UDARA
                      const Text(
                        'Kondisi Saat Ini',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40345F),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Jika AQI null, jangan menganggapnya sebagai 0.
                      if (current.usAqi != null)
                        AirQualityStatusWidget(
                          aqi: current.usAqi!,
                        )
                      else
                        _buildNoData(),

                      const SizedBox(height: 16),

                      // KARTU AQI
                      AqiCard(
                        aqi: current.usAqi ?? 0.0,
                        time: current.time,
                      ),

                      const SizedBox(height: 22),

                      // POLUTAN
                      const Text(
                        'Detail Polutan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40345F),
                        ),
                      ),

                      const SizedBox(height: 12),

                      PollutantCard(
                        pm25: current.pm25 ?? 0.0,
                        pm10: current.pm10 ?? 0.0,
                        carbonMonoxide:
                        current.carbonMonoxide ?? 0.0,
                        nitrogenDioxide:
                        current.nitrogenDioxide ?? 0.0,
                        sulphurDioxide:
                        current.sulphurDioxide ?? 0.0,
                        ozone: current.ozone ?? 0.0,
                      ),

                      const SizedBox(height: 24),
                    ],

                    // DATA PERKIRAAN
                    if (forecast != null) ...[
                      const Text(
                        'Perkiraan Kualitas Udara',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF40345F),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ForecastSection(
                        forecast: forecast,
                      ),

                      const SizedBox(height: 20),
                    ],

                    // LOADING KECIL SAAT MEMPERBARUI DATA
                    if (isLoading && current != null)
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: LinearProgressIndicator(
                          color: Color(0xFF9277D8),
                          backgroundColor: Color(0xFFEDE7FA),
                        ),
                      ),

                    // PESAN ERROR JIKA DATA LAMA MASIH DITAMPILKAN
                    if (hasError && current != null)
                      _buildErrorMessage(
                        viewModel.errorMessage ??
                            'Gagal memperbarui data.',
                      ),

                    // FOOTER
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          'Data kualitas udara disediakan oleh Open-Meteo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Tampilan ketika aplikasi sedang mengambil data.
  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 45),
      child: const Column(
        children: [
          CircularProgressIndicator(
            color: Color(0xFF9277D8),
          ),
          SizedBox(height: 15),
          Text(
            'Sedang mengambil data kualitas udara...',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF706487),
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan ketika data tidak berhasil diperoleh.
  Widget _buildError(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.red.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 40,
            color: Colors.redAccent,
          ),
          const SizedBox(height: 12),
          const Text(
            'Data Tidak Tersedia',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF40345F),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9277D8),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Tampilan ketika data AQI belum tersedia.
  Widget _buildNoData() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(0xFF9277D8),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Informasi AQI belum tersedia untuk lokasi ini.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF40345F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pesan error ringan ketika data sebelumnya masih ditampilkan.
  Widget _buildErrorMessage(String message) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.deepOrange,
        ),
      ),
    );
  }
}
