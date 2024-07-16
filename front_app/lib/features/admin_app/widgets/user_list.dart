import 'package:barassage_app/features/admin_app/widgets/user_card.dart';
import 'package:barassage_app/features/auth_mod/models/user.dart';
import 'package:flutter/material.dart';

class UserList extends StatelessWidget {
  final List<User> users;
  final Function(User) onDetailsPressed;

  const UserList(
      {super.key, required this.users, required this.onDetailsPressed});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return UserCard(
          user: users[index],
          onDetailsPressed: onDetailsPressed,
          badgeText: 'Admin',
        );
      },
    );
  }
}
