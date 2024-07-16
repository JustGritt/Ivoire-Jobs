import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
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
        return secondary;
      default:
        return primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.all(8),
      color: Colors.grey[100],
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
                    color: primary,
                  ),
                )
              : null,
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primary,
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
                color: primary,
              ),
          ],
        ),
      ),
    );
  }
}
