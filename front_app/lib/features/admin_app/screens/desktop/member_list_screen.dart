import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/models/member.dart';
import 'package:barassage_app/features/admin_app/providers/members_provider.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AdminService _adminService = serviceLocator<AdminService>();

class MemberListScreen extends StatefulWidget {
  const MemberListScreen({super.key});

  @override
  State<MemberListScreen> createState() => _MemberListScreenState();
}

class _MemberListScreenState extends State<MemberListScreen> {
  late Future<List<Member>> membersListFuture;
  String selectedStatus = 'All';

  @override
  void initState() {
    super.initState();
    membersListFuture = fetchMembersList();
  }

  Future<List<Member>> fetchMembersList() async {
    final membersProvider =
    Provider.of<MembersProvider>(context, listen: false);
    await membersProvider.getMembers();
    return membersProvider.members;
  }

  void _handleStatusFilter(String status) {
    setState(() {
      selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Members',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: primary, width: 2.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedStatus,
                      onChanged: (String? newValue) {
                        _handleStatusFilter(newValue ?? 'All');
                      },
                      items: <String>['All', 'member', 'processing', 'rejected']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style:
                            const TextStyle(fontSize: 16, color: primary),
                          ),
                        );
                      }).toList(),
                      icon: Icon(Icons.arrow_drop_down, color: primary),
                      dropdownColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<Member>>(
              future: membersListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading the member list'));
                } else {
                  return Consumer<MembersProvider>(
                    builder: (context, membersProvider, child) {
                      if (membersProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (membersProvider.members.isEmpty) {
                        return const Center(
                            child: Text('No members available'));
                      } else {
                        List<Member> filteredMembers = selectedStatus == 'All'
                            ? membersProvider.members
                            : membersProvider.members
                            .where(
                                (member) => member.status == selectedStatus)
                            .toList();

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int crossAxisCount = constraints.maxWidth > 1280
                                ? 3
                                : constraints.maxWidth > 1024
                                ? 2
                                : 1;
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: GridView.builder(
                                gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3,
                                ),
                                itemCount: filteredMembers.length,
                                itemBuilder: (context, index) {
                                  final member = filteredMembers[index];
                                  return _buildMemberCard(member, theme);
                                },
                              ),
                            );
                          },
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMemberCard(Member member, ThemeData theme) {
    return Card(
      color: Colors.grey[100],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.person,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${member.user!.firstName} ${member.user!.lastName}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: theme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.email,
                    color: theme.primaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    member.user!.email,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              member.status,
              style: member.status == 'member'
                  ? const TextStyle(
                fontSize: 16,
                color: Colors.green,
              )
                  : member.status == 'processing'
                  ? const TextStyle(
                fontSize: 16,
                color: Colors.orange,
              )
                  : const TextStyle(
                fontSize: 16,
                color: Colors.red,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}