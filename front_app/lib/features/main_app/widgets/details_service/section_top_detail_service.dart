import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:flutter/material.dart';

class SectionTopDetailService extends StatefulWidget {
  final ServiceCreatedModel service;
  const SectionTopDetailService({super.key, required this.service});

  @override
  State<SectionTopDetailService> createState() =>
      _SectionTopDetailServiceState();
}

class _SectionTopDetailServiceState extends State<SectionTopDetailService> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.service.category.first,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  color: theme.scaffoldBackgroundColor,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.service.duration}'.durationToTime,
                  style: TextStyle(
                    color: theme.scaffoldBackgroundColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
    );
  }
}
