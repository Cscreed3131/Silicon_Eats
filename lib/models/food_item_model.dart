class FoodItem {
  final String addedBy;
  final DateTime dateAndTime;
  final String name;
  final String description;
  final double costPrice;
  final double sellingPrice;
  final String category;
  final String imageUrl;
  final bool available;
  final int id;

  FoodItem({
    required this.addedBy,
    required this.dateAndTime,
    required this.name,
    required this.description,
    required this.costPrice,
    required this.sellingPrice,
    required this.category,
    required this.imageUrl,
    required this.available,
    required this.id,
  });

  // Map<String, dynamic> toMap() {
  //   return {
  //     'added_by': addedBy,
  //     'date_and_time': dateAndTime,
  //     'name': name,
  //     'description': description,
  //     'costPrice': costPrice,
  //     'sellingPrice': sellingPrice,
  //     'category': category,
  //     'imageUrl': imageUrl,
  //     'available': available,
  //     'id': id,
  //   };
  // }

  // factory FoodItem.fromMap(Map<String, dynamic> map) {
  //   return FoodItem(
  //     addedBy: map['added_by'],
  //     dateAndTime: map['date_and_time'].toDate(),
  //     name: map['name'],
  //     description: map['description'],
  //     costPrice: map['costPrice'],
  //     sellingPrice: map['sellingPrice'],
  //     category: map['category'],
  //     imageUrl: map['imageUrl'],
  //     available: map['available'],
  //     id: map['id'],
  //   );
  // }
}
