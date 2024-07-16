import 'package:barassage_app/features/main_app/widgets/services/my_service_slidable_item.dart';
import 'package:barassage_app/features/main_app/widgets/services/my_service_item.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore_for_file: deprecated_member_use

class Service extends StatefulWidget {
  final String? title;
  const Service({super.key, this.title});

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {
  late TextEditingController _name;
  @override
  void initState() {
    super.initState();
    final myServicesProvider =
        Provider.of<MyServicesProvider>(context, listen: false);
    myServicesProvider.getAll();
    _name = TextEditingController(text: 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SuperScaffold(
      appBar: SuperAppBar(
        shadowColor: Colors.grey,
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(widget.title!),
        largeTitle: SuperLargeTitle(
          largeTitle: widget.title!,
          actions: [
            CupertinoButton(
              onPressed: () => {
                context.push('${App.services}/${App.serviceNew}'),
              },
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  Text('Add',
                      style: theme.textTheme.displayMedium!.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      )),
                  Icon(
                    CupertinoIcons.plus,
                    color: theme.primaryColor,
                    size: 20.0,
                  ),
                ],
              ),
            )
          ],
        ),
        titleSpacing: 0.0,
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
      body: Consumer<MyServicesProvider>(
        builder: (_, np, __) {
          if (np.isLoading == false) {
            if (np.services.isEmpty) {
              return const Center(
                child: Text(
                  'No services found',
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              separatorBuilder: (_, index) => const SizedBox(height: 14),
              itemCount: np.services.length,
              itemBuilder: (_, index) {
                return MyServiceSlidable(
                    onDelete: (handler) async {
                      bool success =
                          await np.deleteService(np.services[index].id);
                      await handler(success);
                    },
                    child: MyServiceItem(
                      serviceModel: np.services[index],
                    ));
              },
            );
          } else {
            return const Center(
              child: Text('Services data loading....'),
            );
          }
        },
      ),
    );
  }
}
