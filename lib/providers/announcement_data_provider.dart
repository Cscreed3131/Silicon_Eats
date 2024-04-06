import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/announcement.dart';

final announcementsStreamProvider = StreamProvider<List<Announcements>>(
  (ref) {
    return FirebaseFirestore.instance
        .collection('announcements')
        .orderBy('dateAndTime', descending: true)
        .limit(15)
        .snapshots()
        .map(
      (querySnapshot) {
        return querySnapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();
          return Announcements(
            message: data['message'],
            link: data['link'],
            dateTime: (data['dateAndTime'] as Timestamp).toDate(),
          );
        }).toList();
      },
    );
  },
);
