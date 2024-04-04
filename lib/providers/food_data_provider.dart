import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/food_item_model.dart';

final foodItemStreamProvider = StreamProvider<List<FoodItem>>((ref) {
  final CollectionReference foodItemsCollection =
      FirebaseFirestore.instance.collection('foodItems');

  return foodItemsCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      return FoodItem(
        id: doc['id'],
        name: doc['name'],
        category: doc['category'],
        imageUrl: doc['imageUrl'],
        costPrice: doc['costPrice'],
        sellingPrice: doc['sellingPrice'],
        dateAndTime: (doc['dateAndTime'] as Timestamp).toDate(),
        addedBy: doc['addedBy'],
        description: doc['description'],
        available: doc['available'],
      );
    }).toList();
  });
});

final foodItemCountProvider = Provider<int?>((ref) {
  final foodItemList = ref.watch(foodItemStreamProvider);
  return foodItemList.when(
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
