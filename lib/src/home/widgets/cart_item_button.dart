import 'package:flutter/material.dart';
import 'package:sorasummit/providers/cart_provider.dart';
import 'package:sorasummit/src/home/screens/cart_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartButton extends ConsumerWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider.notifier);

    return IconButton(
      icon: Badge(
        label: Text(
          cart.getTotalItemCount().toString(),
          style: const TextStyle(color: Colors.white),
        ),
        child: const Icon(Icons.fastfood),
      ),
      color: Colors.black87,
      iconSize: 30,
      onPressed: () {
        Navigator.of(context).pushNamed(CartScreen.routeName);
      },
    );
  }
}
