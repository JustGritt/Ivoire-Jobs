import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class FilterChips extends StatefulWidget {
  const FilterChips({super.key});

  @override
  _FilterChipsState createState() => _FilterChipsState();
}

class _FilterChipsState extends State<FilterChips> {
  String _selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Consumer<MyServicesProvider>(
      builder: (context, myServicesProvider, child) {
        List<String> filters = ["All"];
        filters.addAll(myServicesProvider.categories.map((category) => category.name).toList());

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters.map((filter) {
                return Padding(
                  padding: EdgeInsets.only(
                      right: 8.0, left: filters.indexOf(filter) == 0 ? 16.0 : 0.0),
                  child: ChoiceChip(
                    label: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: _selectedFilter == filter ? Colors.white : Colors.black,
                      ),
                    ),
                    selected: _selectedFilter == filter,
                    onSelected: (bool selected) {
                      setState(() {
                        _selectedFilter = selected ? filter : _selectedFilter;
                      });
                      myServicesProvider.filterServices(_selectedFilter);
                    },
                    selectedColor: Colors.blue,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: _selectedFilter == filter ? Colors.blue : Colors.white,
                        width: 1.5,
                      ),
                    ),
                    elevation: 4,
                    pressElevation: 6,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}