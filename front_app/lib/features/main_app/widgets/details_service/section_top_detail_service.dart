import 'package:barassage_app/config/config.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/features/main_app/models/service_models/service_created_model.dart';
import 'package:flutter/cupertino.dart';
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.service.category.first,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              widget.service.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // CupertinoButton(
            //   color: AppColors.greyLight,
            //   minSize: 0,
            //   padding: EdgeInsets.all(8),
            //   onPressed: () {
            //     if (hours > 0) {
            //       setState(() {
            //         hours--;
            //       });
            //     }
            //   },
            //   child: const Icon(
            //     Icons.remove,
            //     color: Colors.black,
            //   ),
            // ),
            SizedBox(width: 15,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal:  8, vertical: 4),
              decoration: BoxDecoration(
                color: theme.primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${widget.service.duration}'.durationToTime,
                style: TextStyle(
                  color: theme.scaffoldBackgroundColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // SizedBox(width: 15,),
            // CupertinoButton(
            //   color: AppColors.primaryBlue,
            //   minSize: 0,
            //   padding: EdgeInsets.all(8),
            //   onPressed: () {
            //     setState(() {
            //       hours++;
            //     });
            //   },
            //   child: const Icon(
            //     Icons.add,
            //     color: AppColors.white,
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
