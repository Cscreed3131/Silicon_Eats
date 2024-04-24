import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartController, Cart>((ref) {
  return CartController();
});

class CartController extends StateNotifier<Cart> {
  CartController() : super(Cart());

  void addItem(
      int id, String name, double price, int quantity, String category) {
    state = Cart()
      ..items = List.from(state.items)
      ..addItem(id, name, price, quantity, category);
  }

  void removeItem(int id) {
    state = Cart()
      ..items = List.from(state.items)
      ..removeItem(id);
  }

  void updateItem(int id, int newQuantity) {
    state = Cart()
      ..items = List.from(state.items)
      ..updateItem(id, newQuantity);
  }

  double getItemTotalPrice() {
    return state.getItemTotalPrice();
  }

  double getPlatformFee() {
    return state.getPlatformFee();
  }

  double getTotalPayment() {
    return state.getTotalPayment();
  }

  int getTotalItemCount() {
    return state.getTotalItemCount();
  }

  void clearCart() {
    state = Cart()
      ..items = List.from(state.items)
      ..clearCart();
  }

  List<CartItem> getCartItems() {
    return state.getCartItems();
  }
}
