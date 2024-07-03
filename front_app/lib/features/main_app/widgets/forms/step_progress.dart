import 'package:flutter/material.dart';

class StepProgress extends StatefulWidget {
  final int currentStepIndex;
  const StepProgress({super.key, required this.currentStepIndex});

  @override
  State<StepProgress> createState() => _StepProgressState();
}

class _StepProgressState extends State<StepProgress> {
  @override
  Widget build(BuildContext context) {
    int currentStepIndex = widget.currentStepIndex;
    ThemeData theme = Theme.of(context);
    TextStyle? getIndexTextStyle(int index) {
      return TextStyle(
          height: index == currentStepIndex ? 1.3 : 1.5,
          fontSize: index == currentStepIndex ? 16.0 : 14.0,
          fontWeight:
              index == currentStepIndex ? FontWeight.w700 : FontWeight.w400,
          color: index == currentStepIndex
              ? theme.primaryColorDark
              : theme.textTheme.displayMedium!.color);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations',
                  style: getIndexTextStyle(0),
                ),
                const SizedBox(height: 2.0),
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 9.0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              children: [
                Text(
                  'Localization',
                  style: getIndexTextStyle(1),
                ),
                const SizedBox(height: 2.0),
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 9.0,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              children: [
                Text(
                  'Category',
                  style: getIndexTextStyle(2),
                ),
                const SizedBox(height: 2.0),
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  height: 9.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
