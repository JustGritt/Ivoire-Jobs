import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CABadge extends StatelessWidget {
  Color? color;
  String label;

  CABadge({
    super.key,
    this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 4,
      labelPadding: const EdgeInsets.all(4),

      backgroundColor: color ?? Colors.blue,
      label: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 10)),
    );
  }
}
