import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/admin_dialog.dart';
import 'package:barassage_app/features/admin_app/widgets/user_list.dart';
import 'package:barassage_app/features/admin_app/models/admin_user.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class TeamManagerScreen extends StatefulWidget {
  const TeamManagerScreen({super.key});

  @override
  State<TeamManagerScreen> createState() => _TeamManagerScreenState();
}

class _TeamManagerScreenState extends State<TeamManagerScreen> {
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
      var values = await as.getAllAdminUsers();
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

  void _createAdminUser(
      String firstName, String lastName, String email, String password) async {
    AdminUser newUser = AdminUser(
      firstName: firstName,
      lastName: lastName,
      email: email,
      profilePicture: '',
      bio: '',
      id: '',
      role: 'admin',
      password: password,
    );

    AdminService as = AdminService();
    try {
      await as.createAdminUser(newUser);
      getUsers();
    } catch (e) {
      _showErrorDialog('Failed to create admin user: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDetailsPressed(User user) {
    debugPrint('View details of user: ${user.firstName} ${user.lastName}');
  }

  void _showCreateAdminDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AdminCreationDialog(onCreateAdmin: _createAdminUser);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: getUsers,
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _showCreateAdminDialog,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                          backgroundColor: primary,
                          shadowColor: primary,
                          foregroundColor: Colors.white,
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text(
                          'Create New Admin',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: UserList(
                      users: users,
                      onDetailsPressed: _handleDetailsPressed,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
