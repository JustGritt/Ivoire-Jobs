import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter/material.dart';

class ReportSearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final ValueChanged<String> onChanged;

  const ReportSearchInput({
    required this.textController,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          color: Colors.grey.withOpacity(.1),
        ),
      ]),
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: primary),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
      ),
    );
  }
}
