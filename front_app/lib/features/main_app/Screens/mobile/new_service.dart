import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/features/main_app/widgets/forms/step_progress.dart';
import 'package:barassage_app/features/main_app/widgets/forms/steps/vertical_steps_informations/vertical_steps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class NewServicePage extends StatefulWidget {
  const NewServicePage({super.key});

  @override
  State<NewServicePage> createState() => _NewServicePageState();
}

class _NewServicePageState extends State<NewServicePage> {
  final String jsonString = "";
  int currentPageIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
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
            child: StepProgress(currentStepIndex: currentPageIndex),
          ),
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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              VerticalSteps(scrollToTop: () {
                _scrollController.animateTo(0.0,
                    duration: const Duration(milliseconds: 10),
                    curve: Curves.slowMiddle);
              }),
              Container(
                color: Colors.blue,
              ),
              Container(
                color: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
