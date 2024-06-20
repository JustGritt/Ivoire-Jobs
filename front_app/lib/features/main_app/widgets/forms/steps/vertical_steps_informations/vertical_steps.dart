import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/step_information.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/step_time_service.dart';
import 'package:flutter/material.dart';

class VerticalSteps extends StatefulWidget {
  final Function scrollToTop;
  final Function(Map<String, dynamic>) nextPage;
  const VerticalSteps({super.key, required this.scrollToTop, required this.nextPage});

  @override
  State<VerticalSteps> createState() => _VerticalStepsState();
}

class _VerticalStepsState extends State<VerticalSteps> {
  final _pageController = PageController();
  Map<String, dynamic> form = {};

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        StepInformation(
          onEnd: (data) => {
            form = data.toJson(),
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutQuad),
            widget.scrollToTop(),
          }
        ),
        StepTimeService(
          onEnd: (timeService) => {
            form['timeService'] = timeService,
            widget.nextPage({'timeService': timeService}),
          },
        ),
      ],
    );
  }
}
