import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/user_detail.dart';
import 'package:barassage_app/features/admin_app/widgets/user_card.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  void getUsers() async {
    setState(() {
      isLoading = true;
    });

    AdminService as = AdminService();
    try {
      var values = await as.getAllUsers();
      if (values != null) {
        debugPrint('values: $values');
        setState(() {
          users = values.cast<User>();
          isLoading = false;
        });
      } else {
        debugPrint('Error: Unexpected response type');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        users = [];
        isLoading = false;
      });
    }
  }

  void _goToUserDetails(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsScreen(user: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                getUsers();
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return UserCard(
                    user: users[index],
                    onDetailsPressed: _goToUserDetails,
                  );
                },
              ),
            ),
    );
  }
}
