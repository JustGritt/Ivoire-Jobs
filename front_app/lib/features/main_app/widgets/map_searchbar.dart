import 'package:flutter/material.dart';

class MapSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onSearch;
  final VoidCallback onAnimatePosition;
  final VoidCallback onListen;
  final bool isListening;

  MapSearchBar({
    required this.searchController,
    required this.onSearch,
    required this.onAnimatePosition,
    required this.onListen,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
                onSubmitted: (value) => onSearch(),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: onSearch,
            ),
            IconButton(
              icon: const Icon(Icons.location_on),
              onPressed: onAnimatePosition,
            ),
            IconButton(
              icon: Icon(
                Icons.mic,
                color: isListening ? Colors.red : Colors.black,
              ),
              onPressed: onListen,
            ),
          ],
        ),
      ),
    );
  }
}
