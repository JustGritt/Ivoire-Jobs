import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class UnderMaintenanceScreen extends StatefulWidget {
  const UnderMaintenanceScreen({super.key});

  @override
  State<UnderMaintenanceScreen> createState() => _UnderMaintenanceScreenState();
}

class _UnderMaintenanceScreenState extends State<UnderMaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      color: AppColors.primaryBlueFair,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              flex: 4,
              child: SvgPicture.asset(
                'assets/svg/not_available_ill.svg',
                width: 300,
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Under Maintenance',
                    style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'We are currently under maintenance. Please check back later.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.primaryColorDark.withOpacity(0.6),
                        fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
