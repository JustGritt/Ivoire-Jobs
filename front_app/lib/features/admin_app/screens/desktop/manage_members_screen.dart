import 'package:barassage_app/features/admin_app/providers/members_provider.dart';
import 'package:barassage_app/features/admin_app/screens/desktop/member_list_screen.dart';
import 'package:barassage_app/features/admin_app/services/admin_service.dart';
import 'package:barassage_app/features/admin_app/utils/home_colors.dart';
import 'package:barassage_app/features/admin_app/models/member.dart';
import 'package:barassage_app/core/init_dependencies.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

AdminService adminService = serviceLocator<AdminService>();

class ManageMembersScreen extends StatefulWidget {
  const ManageMembersScreen({super.key});

  @override
  State<ManageMembersScreen> createState() => _ManageMembersScreenState();
}

class _ManageMembersScreenState extends State<ManageMembersScreen> {
  late Future<List<Member>> membersFuture;

  @override
  void initState() {
    super.initState();
    membersFuture = fetchMembers();
  }

  Future<List<Member>> fetchMembers() async {
    final membersProvider =
    Provider.of<MembersProvider>(context, listen: false);
    await membersProvider.getMemberRequests();
    return membersProvider.memberRequests;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primary,
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Members Requests',
                icon: Icon(Icons.people, color: Colors.white),
              ),
              Tab(
                text: 'Members List',
                icon: Icon(Icons.list, color: Colors.white),
              ),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.white,
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Member>>(
              future: membersFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading Member requests'));
                } else {
                  return Consumer<MembersProvider>(
                    builder: (context, membersProvider, child) {
                      if (membersProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (membersProvider.memberRequests.isEmpty) {
                        return const Center(
                            child: Text('No Members requests available'));
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.builder(
                            gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              childAspectRatio: 3 / 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: membersProvider.memberRequests.length,
                            itemBuilder: (context, index) {
                              final memberRequest =
                              membersProvider.memberRequests[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16.0),
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
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            memberRequest.id,
                                            style: theme.textTheme.bodyLarge
                                                ?.copyWith(fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (memberRequest.status == 'processing')
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 4.0),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius:
                                          BorderRadius.circular(8.0),
                                          border:
                                          Border.all(color: Colors.orange),
                                        ),
                                        child: Text(
                                          'Processing',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.description,
                                          color: theme.primaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Reason: ${memberRequest.reason}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        if (memberRequest.status ==
                                            'processing') ...[
                                          ElevatedButton(
                                            onPressed: () async {
                                              await membersProvider
                                                  .approveMemberRequest(
                                                  memberRequest.id,
                                                  'accepted');
                                              setState(() {
                                                membersFuture = fetchMembers();
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              foregroundColor: Colors.white,
                                              backgroundColor: Colors.green,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: const Icon(Icons.check),
                                          ),
                                          const SizedBox(width: 8),
                                        ],
                                        ElevatedButton(
                                          onPressed: () async {
                                            await membersProvider
                                                .approveMemberRequest(
                                                memberRequest.id,
                                                'rejected');
                                            setState(() {
                                              membersFuture = fetchMembers();
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: const Icon(Icons.close),
                                        ),
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
            const MemberListScreen(),
          ],
        ),
      ),
    );
  }
}
