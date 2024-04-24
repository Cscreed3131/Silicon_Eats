import 'package:collection/collection.dart';

class CartItem {
  final String category;
  final int id;
  final String name;
  final double price;
  int quantity;
  // final List categories;

  CartItem({
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    // required this.categories,
  });
}

class Cart {
  List<CartItem> items = [];

  void addItem(
      int id, String name, double price, int quantity, String category) {
    var existingItem = items.firstWhereOrNull((i) => i.id == id);
    if (existingItem != null) {
      // If an item with the same id already exists in the cart, update its quantity
      existingItem.quantity += quantity;
    } else {
      // If no item with the same id exists in the cart, add a new item
      items.add(CartItem(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        category: category,
      ));
    }
  }

  void removeItem(int id) {
    items.removeWhere((item) => item.id == id);
  }

  void updateItem(int id, int newQuantity) {
    var index = items.indexWhere((item) => item.id == id);
    if (index != -1) {
      items[index] = CartItem(
        id: items[index].id,
        name: items[index].name,
        price: items[index].price,
        quantity: newQuantity,
        category: items[index].category,
      );
    }
  }

  double getItemTotalPrice() {
    double totalPrice = 0.0;
    for (var item in items) {
      totalPrice += item.price * item.quantity;
    }
    return totalPrice;
  }

  double getPlatformFee() {
    double totalPrice = getItemTotalPrice();
    if (totalPrice == 0) {
      return 0;
    }
    double fee = (totalPrice * 0.025).roundToDouble();
    return fee > 1 ? fee : 1;
  }

  double getTotalPayment() {
    double totalPrice = getItemTotalPrice();
    double platformFee = getPlatformFee();
    return (totalPrice + platformFee).roundToDouble();
  }

  int getTotalItemCount() {
    int totalItemCount = 0;
    for (var item in items) {
      totalItemCount += item.quantity;
    }

    return totalItemCount;
  }

  void clearCart() {
    // Clear the items after ordering
    items.clear();
  }

  List<CartItem> getCartItems() {
    return items;
  }
}
