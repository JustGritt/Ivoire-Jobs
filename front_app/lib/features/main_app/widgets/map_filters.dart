import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class MapFilterChips extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  MapFilterChips({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<MyServicesProvider>(
          builder: (context, myServicesProvider, child) {
            List<String> filters = ["All"];
            filters.addAll(myServicesProvider.categories
                .map((category) => category.name)
                .toList());

            return Row(
              children: filters.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: selectedFilter == filter ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: selectedFilter == filter,
                    onSelected: (bool selected) {
                      onFilterSelected(filter);
                    },
                    selectedColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(
                        color: selectedFilter == filter ? Colors.black : Colors.black,
                      ),
                    ),
                    elevation: 4,
                    pressElevation: 6,
                    checkmarkColor: selectedFilter == filter ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
