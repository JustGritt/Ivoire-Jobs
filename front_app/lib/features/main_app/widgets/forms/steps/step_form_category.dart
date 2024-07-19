import 'package:barassage_app/features/main_app/models/service_models/service_category_model.dart';
import 'package:barassage_app/features/main_app/services/service_category_services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:barassage_app/core/helpers/extentions/string_extension.dart';
import 'package:barassage_app/features/auth_mod/widgets/app_button.dart';
import 'package:barassage_app/core/blocs/service/service_bloc.dart';
import 'package:barassage_app/core/helpers/utils_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/config/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ServiceCategoryService serviceCategoryService =
    serviceLocator<ServiceCategoryService>();

class StepFormCategory extends StatefulWidget {
  final Function(List<ServiceCategory> selectedCategory) onEnd;
  const StepFormCategory({super.key, required this.onEnd});

  @override
  State<StepFormCategory> createState() => _StepFormCategoryState();
}

class _StepFormCategoryState extends State<StepFormCategory> {
  List<ServiceCategory> selectedCategory = [];

  Future<List<ServiceCategory>> serviceCategories = Future.value([]);

  void validate() {
    if (selectedCategory.isNotEmpty) {
      widget.onEnd(selectedCategory);
    } else {
      showMyDialog(context,
          title: 'Service category',
          content: 'Please select a service category.');
    }
  }

  @override
  initState() {
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
                              if (selectedCategory.contains(category)) {
                                selectedCategory.remove(category);
                              } else {
                                selectedCategory.add(category);
                              }
                            });
                          },
                              selectedCategory:
                                  selectedCategory.contains(categoryService)),
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
        BlocConsumer<ServiceBloc, ServiceCreateState>(listener: (_, state) {
          if (state is CreateServiceFailure) {
            showMyDialog(context,
                title: 'Service', content: state.errorMessage);
          } else if (state is CreateServiceSuccess) {
            context.pushNamed(App.serviceNewSuccess, extra: state);
          }
        }, builder: (context, state) {
          return AppButton(
            isLoading: state is CreateServiceLoading,
            onPressed: validate,
            backgroundColor: theme.primaryColorDark,
            label: appLocalizations.btn_create,
            stretch: true,
          );
        })
      ]),
    );
  }
}

Widget buildCategoryService(BuildContext context,
    {required ServiceCategory currentCategoryService,
    required Function(ServiceCategory) onSelectedCategory,
    required bool selectedCategory}) {
  ThemeData theme = Theme.of(context);
  bool isInactive = !currentCategoryService.status;

  return GestureDetector(
    onTap: () => {
      if (!currentCategoryService.status)
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
                      onSelectedCategory(currentCategoryService);
                    }
                  : null,
            )
          ],
        )),
  );
}
