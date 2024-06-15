import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StepTimeService extends StatefulWidget {
  final Function(int) onStepChange;
  const StepTimeService({super.key, required this.onStepChange});

  @override
  State<StepTimeService> createState() => _StepTimeServiceState();
}

class _StepTimeServiceState extends State<StepTimeService> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
