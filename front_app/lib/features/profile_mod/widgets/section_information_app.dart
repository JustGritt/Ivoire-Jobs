import 'package:barassage_app/core/helpers/profile_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SectionInformationApp extends StatelessWidget {
  const SectionInformationApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    final DateFormat formatter = DateFormat('MM-yyyy');
    String currentDate = formatter.format(DateTime.now());

    return Container(
      width: width * 0.9,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Version 1.18.5 (1185001)',
            style: TextStyle(color: theme.colorScheme.surface),
          ),
          Text(
            '@${currentDate} Developped with ❤️ by ${ProfileHelper.appDeveloppers.join(',')}',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.surface),
          )
        ],
      ),
    );
  }
}
