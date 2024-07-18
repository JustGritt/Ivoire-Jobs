import 'package:barassage_app/features/main_app/Screens/mobile/services_details.dart';
import 'package:barassage_app/features/main_app/widgets/services/my_service_slidable_item.dart';
import 'package:barassage_app/features/main_app/widgets/services/my_service_item.dart';
import 'package:barassage_app/features/main_app/providers/my_services_provider.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';
import 'package:barassage_app/features/main_app/app.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    _name = TextEditingController(text: 'Guest');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final myServicesProvider = Provider.of<MyServicesProvider>(context, listen: false);
      myServicesProvider.getMyServices();
    });
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
          },
          onSubmitted: (query) {
          },
        ),
      ),
      body: Consumer<MyServicesProvider>(
        builder: (_, np, __) {
          if (np.isLoading == false) {
            if (np.myServices.isEmpty) {
              return const Center(
                child: Text(
                  'No services found',
                ),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.only(top: 2, bottom: 10),
              separatorBuilder: (_, index) => const SizedBox(height: 14),
              itemCount: np.myServices.length,
              itemBuilder: (_, index) {
                return MyServiceSlidable(
                    onDelete: (handler) async {
                      bool success = await np.deleteService(np.myServices[index].id);
                      await handler(success);
                    },
                    child: MyServiceItem(
                      serviceModel: np.myServices[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceDetailPage(service: np.services[index]),
                          ),
                        );
                      },
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