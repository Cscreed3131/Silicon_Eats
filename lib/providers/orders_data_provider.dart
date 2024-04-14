import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/order_model.dart';

final ordersStreamProvider = StreamProvider<List<Orders>>((ref) {
  final CollectionReference ordersCollection =
      FirebaseFirestore.instance.collection('orders');

  return ordersCollection.orderBy('timeStamp').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return Orders(
        orderId: doc.id,
        userId: doc['userId'],
        items: doc['items'],
        status: doc['status'],
        timeStamp: doc['timeStamp'],
        totalAmount: doc['totalAmount'],
      );
    }).toList();
  });
});

final orderItemCountProvider = Provider<int?>((ref) {
  final orderList = ref.watch(ordersStreamProvider);

  return orderList.when(
    data: (data) {
      return data.length;
    },
    error: (error, stackTrace) {
      print(error);
      return null;
    },
    loading: () {
      return null;
    },
  );
});
