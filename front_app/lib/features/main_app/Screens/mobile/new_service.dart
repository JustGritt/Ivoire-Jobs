import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/features/main_app/widgets/forms/step_progress.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/step_form_category.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/vertical_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

import '../../widgets/forms/steps/vertical_step_location/step_choose_location.dart';

class NewServicePage extends StatefulWidget {
  const NewServicePage({super.key});

  @override
  State<NewServicePage> createState() => _NewServicePageState();
}

class _NewServicePageState extends State<NewServicePage> {
  final Map<String, dynamic> form = {};
  final ScrollController _scrollController = ScrollController();
  final _pageController = PageController();

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void nextPage(int page, Map<String, dynamic> data) {
    form.addAll(data);
    _scrollController.animateTo(0.0,
        duration: const Duration(milliseconds: 10), curve: Curves.slowMiddle);
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isInitialized = true;
      });
    });
    return Scaffold(
      backgroundColor: AppColors.greyLight,
      resizeToAvoidBottomInset: false,
      body: SuperScaffold(
        scrollController: _scrollController,
        stretch: false,
        appBar: SuperAppBar(
          shadowColor: theme.scaffoldBackgroundColor,
          backgroundColor: AppColors.greyLight,
          title: const Text("Add new service"),
          largeTitle: SuperLargeTitle(
            enabled: true,
            largeTitle: "New service",
          ),
          titleSpacing: 0.0,
          bottom: SuperAppBarBottom(
              enabled: true,
              height: 50.0,
              child: StepProgress(
                currentStepIndex:
                    !_isInitialized ? 0 : _pageController.page!.round(),
              )),
          previousPageTitle: "",
          searchBar: SuperSearchBar(
            enabled: false,
            onChanged: (query) {
              // Search Bar Changes
            },
            onSubmitted: (query) {
              // On Search Bar submitted
            },
            // Add other search bar properties as needed
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              VerticalSteps(
                scrollToTop: () {
                  _scrollController.animateTo(0.0,
                      duration: const Duration(milliseconds: 10),
                      curve: Curves.slowMiddle);
                },
                nextPage: (data) {
                  nextPage(1, data);
                },
              ),
              StepChooseLocation(
                onEnd: (data) => {
                  nextPage(2, {'location': data.toJson()}),
                },
              ),
              StepFormCategory(
                onEnd: (selectedCategory) {
                  print(selectedCategory);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
