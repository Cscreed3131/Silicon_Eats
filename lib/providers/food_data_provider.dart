// Import the necessary libraries.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/food_item_model.dart';

final foodItemStreamProvider = StreamProvider<List<FoodItem>>((ref) {
  final CollectionReference foodItemsCollection =
      FirebaseFirestore.instance.collection('foodItems');
  return foodItemsCollection.orderBy('id').snapshots().map((snapshot) {
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

// Create a provider to get the number of food items in the list.
// This provider will be used to display the number of food items in the UI.
final foodItemCountProvider = Provider<int?>((ref) {
  // Get the list of food items from the stream provider.
  final foodItemList = ref.watch(foodItemStreamProvider);

  // Return the length of the list.
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

// Create a provider to get the name, selling price, and image URL of each food item in the list.
// This provider will be used to display the food items in the UI.
final foodItemNameAndSellingPriceAndImageProvider =
    Provider.autoDispose<List<Map<String, dynamic>>>((ref) {
  // Get the list of food items from the stream provider.
  final foodItemList = ref.watch(foodItemStreamProvider);

  // Return a list of maps, where each map contains the name, selling price, and image URL of a food item.
  return foodItemList.when(
    data: (data) {
      return data.map((item) {
        return {
          'name': item.name,
          'sellingPrice': item.sellingPrice.toInt(),
          'imageUrl': item.imageUrl,
          'category': item
              .category, //added the category so that I do no have to make new provider.
          'id': item.id,
        };
      }).toList();
    },
    error: (error, stackTrace) {
      print(error);
      return [];
    },
    loading: () {
      return [];
    },
  );
});
