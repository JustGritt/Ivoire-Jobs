import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final User user;

  const UserDetailsScreen({super.key, required this.user});

  void _banUser(BuildContext context, String reason) async {
    AdminService as = AdminService();
    try {
      await as.banUser(user.id, reason);
      _showSnackBar(
          context,
          '${user.firstName} ${user.lastName} has been banned for: $reason.',
          Colors.green);
      Navigator.pop(context);
    } catch (e) {
      _showSnackBar(context,
          'Failed to ban ${user.firstName} ${user.lastName}.', Colors.red);
    }
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showBanDialog(BuildContext context) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ban User'),
          content: Container(
            width: MediaQuery.of(context).size.width *
                0.7 *
                2 /
                3, // 70% of 2/3 screen width
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Please provide a reason for banning this user:'),
                const SizedBox(height: 8),
                TextField(
                  controller: reasonController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Reason',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final String reason = reasonController.text.trim();
                if (reason.isNotEmpty) {
                  Navigator.pop(context); // Close the dialog
                  _banUser(
                      context, reason); // Ban the user with the provided reason
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Ban'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${user.firstName} ${user.lastName} Details'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(
              top: 48.0), // Adding top padding of 3rem (48px)
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 2 / 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  user.profilePicture.isNotEmpty
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user.profilePicture),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: Text(
                            '${user.lastName[0]}${user.firstName[0]}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${user.firstName} ${user.lastName}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getBadgeColor(user.member),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              user.member.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Bio:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.bio ?? 'No bio available',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => _showBanDialog(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Ban User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
}
