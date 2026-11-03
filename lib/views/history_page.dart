
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/air_quality_viewmodel.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<AirQualityViewModel>().loadHistory();
    });
  }

  String formatValue(dynamic value) {
    if (value == null) return '-';

    return (value as num).toStringAsFixed(1);
  }

  String formatTime(String value) {
    try {
      final date = DateTime.parse(value);

      return '${date.day.toString().padLeft(2, '0')}/'
          '${date.month.toString().padLeft(2, '0')}/'
          '${date.year} '
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return value;
    }
  }

  Future<void> confirmDeleteAll(
      BuildContext context,
      AirQualityViewModel viewModel,
      ) async {
    if (viewModel.history.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus semua riwayat?'),
          content: const Text(
            'Semua riwayat kualitas udara akan dihapus permanen.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      await viewModel.clearHistory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AirQualityViewModel>(
      builder: (context, viewModel, child) {
        final history = viewModel.history;

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Riwayat Kualitas Udara',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (history.isNotEmpty)
                IconButton(
                  tooltip: 'Hapus semua riwayat',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    confirmDeleteAll(context, viewModel);
                  },
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => viewModel.loadHistory(),
            child: viewModel.isHistoryLoading && history.isEmpty
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : viewModel.historyError != null && history.isEmpty
                ? ListView(
              children: [
                const SizedBox(height: 150),
                const Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(viewModel.historyError!),
                ),
                TextButton(
                  onPressed: () {
                    viewModel.loadHistory();
                  },
                  child: const Text('Coba lagi'),
                ),
              ],
            )
                : history.isEmpty
                ? ListView(
              children: const [
                SizedBox(height: 130),
                Icon(
                  Icons.history,
                  size: 75,
                  color: Color(0xFFB8A8DD),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Belum Ada Riwayat',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40345F),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 35,
                    ),
                    child: Text(
                      'Data kualitas udara yang kamu periksa '
                          'akan tersimpan di sini.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            )
                : ListView.builder(
              physics:
              const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final item = history[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 14,
                  ),
                  elevation: 1,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor:
                              Color(0xFFF0EAFE),
                              child: Icon(
                                Icons.location_on,
                                color: Color(0xFF9277D8),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['city_name']
                                        .toString(),
                                    style: const TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 17,
                                      color: Color(
                                        0xFF40345F,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formatTime(
                                      item['time'].toString(),
                                    ),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () async {
                                await viewModel.deleteHistory(
                                  item['id'] as int,
                                );
                              },
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        Row(
                          children: [
                            const Icon(
                              Icons.air,
                              color: Color(0xFF9277D8),
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'US AQI',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatValue(item['us_aqi']),
                              style: const TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF40345F),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _pollutant(
                              'PM2.5',
                              item['pm25'],
                            ),
                            _pollutant(
                              'PM10',
                              item['pm10'],
                            ),
                            _pollutant(
                              'CO',
                              item['carbon_monoxide'],
                            ),
                            _pollutant(
                              'NO₂',
                              item['nitrogen_dioxide'],
                            ),
                            _pollutant(
                              'SO₂',
                              item['sulphur_dioxide'],
                            ),
                            _pollutant(
                              'O₃',
                              item['ozone'],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _pollutant(String label, dynamic value) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F1FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatValue(value),
            style: const TextStyle(
              color: Color(0xFF40345F),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
