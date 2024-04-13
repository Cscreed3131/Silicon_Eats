import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartController, Cart>((ref) {
  return CartController();
});

class CartController extends StateNotifier<Cart> {
  CartController() : super(Cart());

  void addItem(int id, String name, double price, int quantity) {
    state.addItem(id, name, price, quantity);
  }

  void removeItem(int id) {
    state.removeItem(id);
  }

  void updateItem(int id, int newQuantity) {
    state.updateItem(id, newQuantity);
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
    return state.clearCart();
  }

  List<CartItem> getCartItems() {
    return state.getCartItems();
  }
}
