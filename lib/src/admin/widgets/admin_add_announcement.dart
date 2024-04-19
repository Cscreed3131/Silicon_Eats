// import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:sorasummit/providers/announcement_data_provider.dart';
import 'package:sorasummit/src/admin/screens/create_announcement_screen.dart';

class AdminAnnounceWidget extends ConsumerStatefulWidget {
  const AdminAnnounceWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminAnnounceWidget> createState() =>
      _AdminAnnounceWidgetState();
}

class _AdminAnnounceWidgetState extends ConsumerState<AdminAnnounceWidget> {
  void deleteDocument(DateTime dateAndTime) async {
    CollectionReference announcementCollection =
        FirebaseFirestore.instance.collection('announcements');
    QuerySnapshot querySnapshot = await announcementCollection
        .where('dateAndTime', isEqualTo: Timestamp.fromDate(dateAndTime))
        .get();
    querySnapshot.docs.forEach((doc) async {
      await doc.reference.delete();
      print('Document with ID ${doc.id} deleted successfully.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Center(
            child: ref.watch(announcementsStreamProvider).when(
              data: (data) {
                return Text(
                  data.length.toString(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.08,
                    fontFamily: 'IBMPlexMono',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
              error: (error, stackTrace) {
                return const Text("0");
              },
              loading: () {
                return const Text("0");
              },
            ),
          ),
          Center(
            child: Text(
              'Cafeteria notices this week',
              maxLines: 3,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontFamily: 'IBMPlexMono',
              ),
            ),
          ),
          const SizedBox(height: 20),

          //add announcement button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, CreateAnnouncement.routeName);
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
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 10),
          //list of club announcements, the list items can be edited/deleted
          ref.watch(announcementsStreamProvider).when(data: (data) {
            return SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: ListTile(
                      title: Text(
                        DateFormat('h:mm a, d/M/yy')
                            .format(data[index].dateTime),
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontFamily: 'IBMPlexMono',
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        data[index].message,
                        style: const TextStyle(
                          fontFamily: 'IBMPlexMono',
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        onPressed: () {
                          deleteDocument(data[index].dateTime);
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          }, error: (error, stackTrace) {
            return const Center(
              child: Text("Can't load notices right now"),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }),
        ],
      ),
    );
  }
}
