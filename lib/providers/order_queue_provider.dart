import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/order_model.dart';
import 'package:sorasummit/models/order_queue_model.dart';
import 'package:sorasummit/providers/orders_data_provider.dart';

final ordersQueueProvider = StreamProvider<List<OrderQueue>>((ref) {
  final CollectionReference foodItemsCollection =
      FirebaseFirestore.instance.collection('ordersQueue');

  return foodItemsCollection.orderBy('timeStamp').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return OrderQueue(
        orderId: doc['orderId'],
        status: doc['status'],
        timeStamp: (doc['timeStamp'] as Timestamp).toDate(),
      );
    }).toList();
  });
});

final orderToOrderId = Provider<List<Orders>>((ref) {
  final orderData = ref.watch(ordersQueueProvider);
  final List orderIdList = orderData.when(
    data: (data) {
      List item = [];
      for (var order in data) {
        item.add(order.orderId);
      }
      return item;
    },
    error: (error, stackTrace) {
      return [];
    },
    loading: () {
      return [];
    },
  );
  final matchedOrdersData = ref.watch(ordersStreamProvider);
  List<Orders> items = [];
  matchedOrdersData.when(
    data: (data) {
      for (var element in data) {
        if (orderIdList.contains(element.orderId)) {
          items.add(element);
        }
      }
    },
    error: (error, stackTrace) {},
    loading: () {},
  );
  return items;
});



// final orderByIdProvider = Provider<Orders?>((ref) {
//   final orders = ref.watch(ordersStreamProvider);
//   final orderId = ref.watch(orderIdProvider);

//   return orders.when(
//     data: (data) {
//       return data.firstWhere((order) => order.orderId == orderId);
//     },
//     error: (error, stackTrace) {
//       print(error);
//       return null;
//     },
//     loading: () {
//       return null;
//     },
//   );
// });

