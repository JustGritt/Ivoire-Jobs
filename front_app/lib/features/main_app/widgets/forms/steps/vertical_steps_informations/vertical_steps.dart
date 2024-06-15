import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/step_information.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/step_time_service.dart';
import 'package:flutter/material.dart';

class VerticalSteps extends StatefulWidget {
  final Function scrollToTop;
  const VerticalSteps({super.key, required this.scrollToTop});

  @override
  State<VerticalSteps> createState() => _VerticalStepsState();
}

class _VerticalStepsState extends State<VerticalSteps> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StepInformation(
          onStepChange: (step) => {
            _pageController.animateToPage(step,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad),
            widget.scrollToTop(),
          },
        ),
        StepTimeService(
          onStepChange: (step) => {
            _pageController.animateToPage(step,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad),
            widget.scrollToTop(),
          },
        ),
        Text('Step 3'),
      ],
    );
  }
}
