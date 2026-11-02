import 'package:flutter/material.dart';

class PollutantCard extends StatelessWidget {
  final num pm25;
  final num pm10;
  final num carbonMonoxide;
  final num nitrogenDioxide;
  final num sulphurDioxide;
  final num ozone;

  const PollutantCard({
    super.key,
    required this.pm25,
    required this.pm10,
    required this.carbonMonoxide,
    required this.nitrogenDioxide,
    required this.sulphurDioxide,
    required this.ozone,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.55,
      children: [
        _pollutantItem(
          'PM2.5',
          pm25,
          'µg/m³',
          Icons.blur_on_rounded,
          const Color(0xFFEBA4BB),
        ),
        _pollutantItem(
          'PM10',
          pm10,
          'µg/m³',
          Icons.grain_rounded,
          const Color(0xFFB49AE8),
        ),
        _pollutantItem(
          'Karbon Monoksida',
          carbonMonoxide,
          'µg/m³',
          Icons.cloud_outlined,
          const Color(0xFFE8B77D),
        ),
        _pollutantItem(
          'Nitrogen Dioksida',
          nitrogenDioxide,
          'µg/m³',
          Icons.science_outlined,
          const Color(0xFF83B9C9),
        ),
        _pollutantItem(
          'Sulfur Dioksida',
          sulphurDioxide,
          'µg/m³',
          Icons.bubble_chart_outlined,
          const Color(0xFF91C5A8),
        ),
        _pollutantItem(
          'Ozon',
          ozone,
          'µg/m³',
          Icons.wb_sunny_outlined,
          const Color(0xFFE6C47B),
        ),
      ],
    );
  }

  Widget _pollutantItem(
      String name,
      num value,
      String unit,
      IconData icon,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.17),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF89839D),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF40345F),
                    ),
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFFAAA3B9),
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
