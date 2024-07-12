import 'package:barassage_app/features/admin_app/screens/desktop/user_details_screen.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
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

  DataRow _userDataRow(User user) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              user.profilePicture.isNotEmpty
                  ? CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(user.profilePicture),
                    )
                  : CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Text(
                        '${user.lastName[0]}${user.firstName[0]}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        DataCell(Text(user.email)),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        ),
        DataCell(
          IconButton(
            icon: const Icon(Icons.remove_red_eye),
            onPressed: () => _goToUserDetails(user),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 2 / 3,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh),
                            onPressed: getUsers,
                          ),
                        ],
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columnSpacing: 32.0,
                          dataRowHeight: 70.0,
                          columns: const [
                            DataColumn(
                              label: Text("Name"),
                            ),
                            DataColumn(
                              label: Text("Email"),
                            ),
                            DataColumn(
                              label: Text("Status"),
                            ),
                            DataColumn(
                              label: Text("Details"),
                            ),
                          ],
                          rows: List.generate(
                            users.length,
                            (index) => _userDataRow(users[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
