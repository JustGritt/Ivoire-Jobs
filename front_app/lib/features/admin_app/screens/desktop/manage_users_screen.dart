import 'package:flutter/material.dart';
import '../../../auth_mod/models/user.dart';
import '../../services/admin_service.dart';
import 'user_details_screen.dart'; // Import the UserDetailsScreen

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

  Color _getBadgeColor(UserMemberStatusEnum status) {
    switch (status) {
      case UserMemberStatusEnum.user:
        return Colors.blue;
      case UserMemberStatusEnum.member:
        return Colors.yellow;
      default:
        return Colors.grey;
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
      appBar: AppBar(
        title: const Text(
          'Manage Users',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
        child: Container(
          padding: const EdgeInsets.only(top: 16),
          width: MediaQuery.of(context).size.width * 2 / 3,
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  leading: user.profilePicture.isNotEmpty
                      ? CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(user.profilePicture),
                  )
                      : CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      '${user.lastName[0]}${user.firstName[0]}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        margin: const EdgeInsets.only(left: 42),
                        decoration: BoxDecoration(
                          color: _getBadgeColor(user.member),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.member.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () => _goToUserDetails(user),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
