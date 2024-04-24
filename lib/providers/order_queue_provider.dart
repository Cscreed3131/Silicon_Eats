import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/order_model.dart';
import 'package:sorasummit/models/order_queue_model.dart';
import 'package:sorasummit/models/user_past_orders_model.dart';
import 'package:sorasummit/providers/orders_data_provider.dart';
import 'package:sorasummit/providers/user_data_provider.dart';

// final ordersQueueProvider = StreamProvider<List<OrderQueue?>>((ref) {
//   final CollectionReference orderQueueCollection =
//       FirebaseFirestore.instance.collection('ordersQueue');
//   final DateTime now = DateTime.now();
//   final DateTime startOfDay = DateTime(now.year, now.month, now.day);
//   final DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//   return orderQueueCollection
//       .where('timeStamp',
//           isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
//       .where('timeStamp', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
//       // .orderBy('timeStamp')
//       .snapshots()
//       .map((snapshot) {
//     return snapshot.docs.map((doc) {
//       print(doc['timeStamp']);
//       return OrderQueue(
//         orderId: doc['orderId'],
//         status: doc['status'],
//         timeStamp: doc['timeStamp'],
//       );
//     }).toList();
//   });
// });
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

final userCurrentlyProcessingOrdersProvider =
    StreamProvider<List<UserPastOrders?>>((ref) {
  final userId = ref.watch(userSicProvider);
  final CollectionReference orderedItemCollection =
      FirebaseFirestore.instance.collection('orders');

  // Get the first day of the current month
  final DateTime now = DateTime.now();
  final DateTime firstDayOfMonth = DateTime(now.year, now.month, now.day);

  return orderedItemCollection
      .where('userId', isEqualTo: userId)
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserPastOrders(
                orderId: doc.id,
                userId: doc['userId'],
                items: doc['items'],
                status: doc['status'],
                timeStamp: (doc['timestamp'] as Timestamp).toDate(),
                totalAmount: doc['totalAmount'],
                name: doc['name'],
              ))
          .toList());
});

final userPastOrdersProvider = StreamProvider<List<UserPastOrders?>>((ref) {
  final userId = ref.watch(userSicProvider);
  final CollectionReference orderedItemCollection =
      FirebaseFirestore.instance.collection('orders');

  // Get the first day of the current month
  final DateTime now = DateTime.now();
  final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);

  return orderedItemCollection
      .where('userId', isEqualTo: userId)
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(firstDayOfMonth))
      .where('status', isEqualTo: 'Done')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => UserPastOrders(
                orderId: doc.id,
                userId: doc['userId'],
                items: doc['items'],
                status: doc['status'],
                timeStamp: (doc['timestamp'] as Timestamp).toDate(),
                totalAmount: doc['totalAmount'],
                name: doc['name'],
              ))
          .toList());
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

// final userPendingOrdersProvider = Provider<List<Orders>>(
//   (ref) {
//     final userId = ref.watch(userSicProvider);
//     final orders = ref.watch(orderToOrderIdProvider);
//     List<Orders> userOrders = [];
//     for (var data in orders) {
//       if (data.userId == userId && data.status == 'pending') {
//         userOrders.add(data);
//       }
//     }
//     return userOrders;
//   },
// );
// final userDoneOrdersProvider = Provider<List<Orders>>(
//   (ref) {
//     final userId = ref.watch(userSicProvider);
//     final orders = ref.watch(orderToOrderIdProvider);
//     List<Orders> userOrders = [];
//     for (var data in orders) {
//       if (data.userId == userId && data.status == 'Done') {
//         userOrders.add(data);
//       }
//     }
//     return userOrders;
//   },
// );
