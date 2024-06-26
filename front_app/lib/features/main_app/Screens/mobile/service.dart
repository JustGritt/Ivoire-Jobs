// ignore_for_file: deprecated_member_use
import 'package:barassage_app/features/main_app/app.dart';
import 'package:barassage_app/features/main_app/widgets/services/my_service_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

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
          enabled: true,
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
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            MyServiceItem(),
          ],
        ),
      ),
    );
  }
}
