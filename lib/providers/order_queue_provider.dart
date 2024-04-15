import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/order_model.dart';
import 'package:sorasummit/models/order_queue_model.dart';
import 'package:sorasummit/providers/orders_data_provider.dart';

final ordersQueueProvider = StreamProvider<List<OrderQueue?>>((ref) {
  final CollectionReference foodItemsCollection =
      FirebaseFirestore.instance.collection('ordersQueue');

  return foodItemsCollection.orderBy('timeStamp').snapshots().map((snapshot) {
    return snapshot.docs
        .map((doc) {
          final timeStamp = (doc['timeStamp'] as Timestamp).toDate();
          final today = DateTime.now();
          if (timeStamp.day == today.day &&
              timeStamp.month == today.month &&
              timeStamp.year == today.year) {
            return OrderQueue(
              orderId: doc['orderId'],
              status: doc['status'],
              timeStamp: timeStamp,
            );
          }
        })
        .where((order) => order != null)
        .toList();
  });
});

final orderToOrderIdProvider = Provider<List<Orders>>((ref) {
  final orderData = ref.watch(ordersQueueProvider);
  final matchedOrdersData = ref.watch(ordersStreamProvider);

  return orderData.maybeWhen(
    data: (orders) {
      final orderIdList = orders.map((order) => order?.orderId).toList();

      return matchedOrdersData.maybeWhen(
        data: (matchedOrders) {
          return matchedOrders
              .where((order) => orderIdList.contains(order.orderId))
              .toList();
        },
        orElse: () => [],
      );
    },
    orElse: () => [],
  );
});
