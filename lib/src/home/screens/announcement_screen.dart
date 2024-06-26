import 'package:flutter/material.dart';
import 'package:sorasummit/src/home/widgets/announcement_widget.dart';

class AnnouncementScreen extends StatelessWidget {
  const AnnouncementScreen({super.key});

  static const routeName = '/updates';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).colorScheme.background,
            snap: true,
            floating: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              //added close icon
              icon: const Icon(Icons.close),
            ),
            title: const Text(
              "Announcements",
              style: TextStyle(
                fontFamily: 'NauticalPrestige',
                fontSize: 35,
                fontWeight: FontWeight.bold,
                // color: textColor,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  AnnouncementWidget(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
