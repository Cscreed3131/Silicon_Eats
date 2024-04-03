import 'package:flutter/material.dart';

import 'package:sorasummit/screens/admin/widgets/admin_add_announcement.dart';
import 'package:sorasummit/screens/admin/widgets/admin_add_food_widget.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  static const routeName = '/admin-screen';
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    List adminRole = ["Student", "Admin"];
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Admin Panel',
              style: TextStyle(fontFamily: 'IBMPlexMono'),
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
                    "Anubhav", // should be dynamic
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
                      for (var role in adminRole)
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
                  DefaultTabController(
                    length: 2,
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
                        // Tab(
                        //   text: 'Events',
                        // ),
                        // Tab(
                        //   text: 'Merch',
                        // ),
                        Tab(
                          text: 'Announcements',
                        ),
                        Tab(
                          text: 'Food',
                        ),
                        // Tab(
                        //   text: 'Timetable',
                        // ),
                        // Tab(
                        //   text: 'Placements',
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.8,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: const [
                        // AdminEventsWidget(),
                        // AdminMerchWidget(),
                        AdminAnnounceWidget(), //use this
                        AdminAddFoodWidget(), // use this
                        // AdminTimetableWidget(),
                        // AdminAddPlacementsData(),
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
