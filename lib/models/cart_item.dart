import 'package:collection/collection.dart';

class CartItem {
  final int id;
  final String name;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });
}

class Cart {
  List<CartItem> items = [];

  void addItem(int id, String name, double price, int quantity) {
    var existingItem = items.firstWhereOrNull((i) => i.id == id);
    if (existingItem != null) {
      // If an item with the same id already exists in the cart, update its quantity
      existingItem.quantity += quantity;
    } else {
      // If no item with the same id exists in the cart, add a new item
      items.add(CartItem(id: id, name: name, price: price, quantity: quantity));
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
}
