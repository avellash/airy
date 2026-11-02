import 'package:flutter/material.dart';
import '../../models/city_model.dart';

class CitySelector extends StatelessWidget {
  final List<CityModel> cities;
  final CityModel selectedCity;
  final ValueChanged<CityModel> onChanged;

  const CitySelector({
    super.key,
    required this.cities,
    required this.selectedCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9277D8).withOpacity(0.07),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_rounded,
            color: Color(0xFF9277D8),
          ),
          const SizedBox(width: 12),
          const Text(
            'Lokasi',
            style: TextStyle(
              color: Color(0xFF625879),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          DropdownButton<CityModel>(
            value: selectedCity,
            underline: const SizedBox(),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF9277D8),
            ),
            borderRadius: BorderRadius.circular(15),
            items: cities.map((city) {
              return DropdownMenuItem<CityModel>(
                value: city,
                child: Text(
                  city.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF40345F),
                  ),
                ),
              );
            }).toList(),
            onChanged: (city) {
              if (city != null) {
                onChanged(city);
              }
            },
          ),
        ],
      ),
    );
  }
}
