import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/widgets/user_detail.dart';
import 'package:barassage_app/features/admin_app/widgets/user_card.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<User> users = [];
  List<User> filteredUsers = [];
  bool isLoading = true;
  final TextEditingController _searchController = TextEditingController();

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
          filteredUsers = users;
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
        filteredUsers = [];
        isLoading = false;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      filteredUsers = users.where((user) {
        final userName = user.firstName.toLowerCase() + ' ' + user.lastName.toLowerCase();
        final searchQuery = query.toLowerCase();
        return userName.contains(searchQuery);
      }).toList();
    });
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
          : Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Number of users: ${filteredUsers.length}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.refresh, color: primary),
                            onPressed: () {
                              getUsers();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      UserSearchInput(
                        textController: _searchController,
                        hintText: 'Search Users',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      getUsers();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return UserCard(
                          user: filteredUsers[index],
                          onDetailsPressed: _goToUserDetails,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class UserSearchInput extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  const UserSearchInput({required this.textController, required this.hintText, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          offset: const Offset(12, 26),
          blurRadius: 50,
          spreadRadius: 0,
          color: Colors.grey.withOpacity(.1),
        ),
      ]),
      child: TextField(
        controller: textController,
        onChanged: (value) {
          if (context.findAncestorStateOfType<_ManageUsersScreenState>() != null) {
            context.findAncestorStateOfType<_ManageUsersScreenState>()!._handleSearch(value);
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: primary),
          filled: true,
          fillColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 2.0),
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          ),
        ),
      ),
    );
  }
}
