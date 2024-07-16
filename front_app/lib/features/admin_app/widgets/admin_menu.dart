import 'package:barassage_app/core/blocs/authentication/authentication_bloc.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

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
        iconTheme: IconThemeData(
          color: primary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: primary),
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
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/dashboard');
              },
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: primary,
                ),
                child: const Text(
                  'Barassage Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people, color: primary),
              title: const Text('Manage Users'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/users');
              },
            ),
            ListTile(
              leading: Icon(Icons.build, color: primary),
              title: const Text('Manage Services'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/services');
              },
            ),
            ListTile(
              leading: Icon(Icons.warning, color: primary),
              title: const Text('Reports'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/reports');
              },
            ),
            ListTile(
              leading: Icon(Icons.block, color: primary),
              title: const Text('Ban List'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/banlist');
              },
            ),
            ListTile(
              leading: Icon(Icons.people, color: primary),
              title: const Text('Manage members'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/members');
              },
            ),
            ListTile(
              leading: Icon(Icons.category, color: primary),
              title: const Text('Manage Categories'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/categories');
              },
            ),
            ListTile(
              leading: Icon(Icons.book, color: primary),
              title: const Text('Manage Bookings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/booking');
              },
            ),
            ListTile(
              leading: Icon(Icons.people_alt_outlined, color: primary),
              title: const Text('Manage Teams'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/teams');
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: primary),
              title: const Text('Logs'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/logs');
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: primary),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                context.go('/admin/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout, color: primary),
              title: const Text('Logout'),
              onTap: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AdminSignOut());
              },
            ),
          ],
        ),
      ),
      body: body,
    );
  }
}
