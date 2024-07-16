import 'package:barassage_app/core/init_dependencies.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/members_provider.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  late Future<void> membersFuture;

  @override
  void initState() {
    super.initState();
    membersFuture = fetchMembers();
  }

  Future<void> fetchMembers() async {
    final membersProvider =
    Provider.of<MembersProvider>(context, listen: false);
    await membersProvider.getMemberRequests();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: FutureBuilder<void>(
        future: membersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading Member requests'));
          } else {
            return Consumer<MembersProvider>(
              builder: (context, membersProvider, child) {
                if (membersProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (membersProvider.members.isEmpty) {
                  return Center(child: Text('No Members requests available'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(
                        10.0), // Added padding to the outer container
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        childAspectRatio: 2 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: membersProvider.members.length,
                      itemBuilder: (context, index) {
                        final member = membersProvider.members[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.people,
                                    color: theme.primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      member.id,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(fontSize: 24),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    member.status,
                                    style: theme.textTheme.bodyMedium
                                        ?.copyWith(fontSize: 18),
                                  ),
                                  if (member.status == 'processing') ...[
                                    ElevatedButton(
                                      onPressed: () {
                                        membersProvider.approveMemberRequest(
                                            member.id, 'accepted');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                        Colors.black, // button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Icon(Icons.check),
                                    ),
                                    SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () {
                                        membersProvider.approveMemberRequest(
                                            member.id, 'rejected');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                        Colors.red, // button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Icon(Icons.close),
                                    ),
                                  ] else ...[
                                    ElevatedButton(
                                      onPressed: () {
                                        membersProvider.approveMemberRequest(
                                            member.id, 'rejected');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                        Colors.red, // button color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      child: Icon(Icons.close),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}