import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/providers/user_data_provider.dart';

import 'package:sorasummit/src/admin/widgets/admin_add_announcement.dart';
import 'package:sorasummit/src/admin/widgets/admin_add_food_widget.dart';
import 'package:sorasummit/src/admin/widgets/admin_manage_items.dart';

class AdminHomeScreen extends ConsumerStatefulWidget {
  const AdminHomeScreen({super.key});
  static const routeName = '/admin-screen';
  @override
  ConsumerState<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends ConsumerState<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userName = ref.watch(userNameProvider);
    final adminRole = ref.watch(userRoleProvider);
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: Text.rich(
              TextSpan(
                text: 'Admin ',
                style: const TextStyle(
                  fontFamily: 'NauticalPrestige',
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'Panel',
                    style: TextStyle(
                      fontFamily: 'NauticalPrestige',
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.help),
                      title: Text('Help'),
                    ),
                  ),
                  const PopupMenuItem(
                    child: ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text('FAQ'),
                    ),
                  ),
                ],
              )
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName, // should be dynamic
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'IBMPlexMono',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  // chip specifying admin role
                  // I want to fetch user roles from my provider which i know
                  // is list of strings and then generate chips based on that.

                  Row(
                    children: [
                      for (var role in adminRole!)
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Chip(
                            side: BorderSide.none,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            label: Text(
                              role
                                  .toString()
                                  .toUpperCase(), // changes done see same in cliff project
                              style: const TextStyle(
                                fontFamily: 'IBMPlexMono',
                                fontWeight: FontWeight.bold,
                                // color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),

                  //tabview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      DefaultTabController(
                        length: 3,
                        child: TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          labelColor: Theme.of(context).colorScheme.primary,
                          unselectedLabelColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                          indicatorColor: Theme.of(context).colorScheme.primary,
                          tabs: const [
                            Tab(
                              text: 'Food',
                            ),
                            Tab(
                              text: 'Manage',
                            ),
                            Tab(
                              text: 'Announcements',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.8,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: const [
                        AdminAddFoodWidget(),
                        AdminManageItemsmWidget(),
                        AdminAnnounceWidget(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
