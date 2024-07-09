import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).add(AdminSignOut());
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                context.go('/admin/users');
              },
            ),
            ListTile(
              leading: const Icon(Icons.build),
              title: const Text('Manage Services'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/services');
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/reports');
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Ban List'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/ban-list');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context).add(AdminSignOut());
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
