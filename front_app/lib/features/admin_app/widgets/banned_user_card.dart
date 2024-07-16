import 'package:barassage_app/features/admin_app/models/banned_user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BannedUserCard extends StatelessWidget {
  final BannedUser bannedUser;
  const BannedUserCard({super.key, required this.bannedUser});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User ID: ${bannedUser.userId}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Banned At: ${DateFormat.yMMMd().format(bannedUser.createdAt)}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Reason: ${bannedUser.reason}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Number of Reports: ${bannedUser.nbReports}',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Handle unban user
                  print('Unbanning user...');
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  backgroundColor: Colors.redAccent,
                  shadowColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Unban'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
