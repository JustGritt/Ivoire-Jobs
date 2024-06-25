import 'package:barassage_app/config/app_colors.dart';
import 'package:barassage_app/core/helpers/extentions/truncate_string_extension.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/models/service_category_model.dart';
import 'package:barassage_app/features/main_app/services/service_category_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pushable_button/pushable_button.dart';

class StepFormCategory extends StatefulWidget {
  final Function(ServiceCategory selectedCategory) onEnd;
  const StepFormCategory({super.key, required this.onEnd});

  @override
  State<StepFormCategory> createState() => _StepFormCategoryState();
}

class _StepFormCategoryState extends State<StepFormCategory> {
  ServiceCategory? selectedCategory;

  Future<List<ServiceCategory>> serviceCategories = Future.value([]);

  void validate() {
    if (selectedCategory != null) {
      widget.onEnd(selectedCategory!);
    } else {
      showMyDialog(context,
          title: 'Service category',
          content: 'Please select a service category.');
    }
  }

  @override
  initState() {
    ServiceCategoryService serviceCategoryService =
        serviceLocator<ServiceCategoryService>();
    serviceCategories = serviceCategoryService.getAll();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    ThemeData theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(appLocalizations.service_category,
            style: theme.textTheme.labelLarge),
        const SizedBox(
          height: 12,
        ),
        AnimationLimiter(
          child: FutureBuilder(
            future: serviceCategories,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              List<ServiceCategory> serviceCategory = snapshot.data!;
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(
                  height: 12,
                ),
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: serviceCategory.length,
                itemBuilder: (BuildContext context, int index) {
                  ServiceCategory categoryService = serviceCategory[index];
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 20.0,
                        child: FadeInAnimation(
                          child: buildCategoryService(context,
                              currentCategoryService: categoryService,
                              onSelectedCategory: (category) {
                            setState(() {
                              if (selectedCategory?.id == category.id) {
                                selectedCategory = null;
                              } else {
                                selectedCategory = category;
                              }
                            });
                          },
                              selectedCategory:
                                  selectedCategory?.id == categoryService.id),
                        ),
                      ));
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 32,
        ),

        // Next button
        PushableButton(
          height: 40,
          elevation: 3,
          hslColor: HSLColor.fromColor(theme.primaryColor),
          shadow: BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 2),
          ),
          onPressed: validate,
          child: Text(appLocalizations.btn_create,
              style: theme.textTheme.titleMedium!
                  .copyWith(color: theme.scaffoldBackgroundColor)),
        ),
      ]),
    );
  }
}

Widget buildCategoryService(BuildContext context,
    {required ServiceCategory currentCategoryService,
    required Function(ServiceCategory) onSelectedCategory,
    required bool selectedCategory}) {
  ThemeData theme = Theme.of(context);
  bool isInactive =
      currentCategoryService.status == ServiceCategoryStatus.inactive;

  return GestureDetector(
    onTap: () => {
      if (currentCategoryService.status == ServiceCategoryStatus.inactive)
        {
          showMyDialog(context,
              title: 'Service category',
              content:
                  'This category is inactive, please contact the administrator to activate it.')
        }
      else
        {onSelectedCategory(currentCategoryService)}
    },
    child: Container(
        decoration: BoxDecoration(
            color: isInactive
                ? AppColors.grey.withOpacity(.3)
                : theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ]),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(Icons.category, color: theme.primaryColor),
            const SizedBox(
              width: 12,
            ),
            Text(currentCategoryService.name.truncateTo(20),
                style: theme.textTheme.displayMedium
                    ?.copyWith(color: theme.primaryColorDark)),
            const SizedBox(
              width: 12,
            ),
            const Spacer(),
            // checkbox
            CupertinoCheckbox(
              value: selectedCategory,
              inactiveColor: AppColors.greyFair.withOpacity(0.5),
              activeColor: theme.primaryColorDark,
              checkColor: theme.primaryColor,
              onChanged: isInactive
                  ? (value) {
                      print(value);
                      onSelectedCategory(currentCategoryService);
                    }
                  : null,
            )
          ],
        )),
  );
}
