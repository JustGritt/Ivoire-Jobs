import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;
  final Function(User) onDetailsPressed;
  final String badgeText;

  const UserCard({
    super.key,
    required this.user,
    required this.onDetailsPressed,
    this.badgeText = 'User',
  });

  Color _getBadgeColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey[200],
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: user.profilePicture.isNotEmpty
              ? NetworkImage(user.profilePicture)
              : null,
          child: user.profilePicture.isEmpty
              ? Text(
                  '${user.lastName[0]}${user.firstName[0]}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(user.email),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: _getBadgeColor(badgeText),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (badgeText.toLowerCase() != 'admin')
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => onDetailsPressed(user),
              ),
          ],
        ),
      ),
    );
  }
}
