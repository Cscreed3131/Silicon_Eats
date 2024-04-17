import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/user_data_model.dart';

// this auto dispose thing is very big problem for the database it request every
// time something a widget is disposed.
// so if the widget is not destroyed we can save some money by sending less requests to the data base.
final userDataProvider = StreamProvider<UserDataModel>((ref) {
  // Use authChanges to automatically handle user authentication changes
  final stream = FirebaseAuth.instance.authStateChanges().asyncExpand(
    (user) async* {
      if (user == null) {
      } else {
        // User is logged in, fetch user details
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (userDoc.docs.isNotEmpty) {
          final userData = userDoc.docs.first.data();
          yield UserDataModel(
            userName: userData['name'],
            userSic: userData['sic'],
            userBranch: userData['branch'],
            userYear: userData['year'],
            userPhoneNumber: num.parse(userData['phoneNumber']),
            userEmail: userData['email'],
            // userimageUrl: userData['image_url'],
            userOrderedFood: userData['orderedFood'],
            userLikedItems: userData['likedItems'],
            userCart: userData['cart'],
            userRoles: userData['userRole'],
          );
        } else {
          // User document not found, yield an empty UserDetails
          // yield UserDetails();
          // You may need to adjust UserDetails constructor
        }
      }
    },
  );

  // Dispose the stream when the provider is disposed
  ref.onDispose(() {
    stream.drain(); // Ensure that the stream is closed
  });

  return stream;
});

final userNameProvider = Provider<String>((ref) {
  final userDataAsyncValue = ref.watch(userDataProvider);

  return userDataAsyncValue.map(
    data: (userData) => userData.value.userName,
    loading: (_) => 'Loading',
    error: (_) => 'Error',
  );
});

final userRoleProvider = Provider<List?>((ref) {
  final userDataAsyncValue = ref.watch(userDataProvider);

  return userDataAsyncValue.map(
    data: (userData) => userData.value.userRoles,
    loading: (_) => [],
    error: (_) => null,
  );
});

final userSicProvider = Provider<String>((ref) {
  final userDataAsyncValue = ref.watch(userDataProvider);

  return userDataAsyncValue.map(
    data: (userData) => userData.value.userSic,
    loading: (_) => 'Loading',
    error: (_) => 'Error',
  );
});
