// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminAnnounceWidget extends StatefulWidget {
  const AdminAnnounceWidget({Key? key}) : super(key: key);

  @override
  State<AdminAnnounceWidget> createState() => _AdminAnnounceWidgetState();
}

class _AdminAnnounceWidgetState extends State<AdminAnnounceWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              '10',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.08,
                fontFamily: 'IBMPlexMono',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Center(
              child: Text(
            'club announcements this month',
            maxLines: 3,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontFamily: 'IBMPlexMono',
            ),
          )),
          const SizedBox(height: 20),

          //add announcement button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigator.pushNamed(context, CreateAnnouncement.routeName);
              },
              icon: const Icon(Icons.add),
              label: Text(
                'Add Announcement',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontFamily: 'IBMPlexMono',
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Announcements',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontFamily: 'IBMPlexMono',
            ),
          ),
          const SizedBox(height: 10),
          //list of club announcements, the list items can be edited/deleted
          ...List.generate(
            10,
            (j) => Card(
              child: ListTile(
                title: Text(
                  'Club Announcement ${(j + 1).toString()}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontFamily: 'IBMPlexMono',
                  ),
                ),
                subtitle: Text(
                  'Announcement description  ${(j + 1).toString()}',
                  style: const TextStyle(
                    fontFamily: 'IBMPlexMono',
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
