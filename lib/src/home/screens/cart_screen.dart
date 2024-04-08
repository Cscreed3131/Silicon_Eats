import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(
              'Cart',
              style: TextStyle(
                fontFamily: 'IBMPLexMono',
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
