import 'package:flutter/material.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;

  HomeSearchBar({
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
      child: GestureDetector(
        onTap: onSearch,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              const SizedBox(width: 8),
              Icon(Icons.search, color: Colors.grey,),
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(left: 8),
                    border: InputBorder.none,
                    hintText: 'Your location',
                    helperStyle: TextStyle(color: Colors.grey, fontSize: 12),
                    hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                  ),
                  enabled: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
