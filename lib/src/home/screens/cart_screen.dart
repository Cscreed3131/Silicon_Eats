import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:sorasummit/providers/cart_provider.dart';
import 'package:sorasummit/providers/user_data_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';
  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);
    final cartController = ref.watch(cartProvider.notifier);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final cartItemsLength = cartController.getCartItems().isEmpty;
    void showSnackbar(String message) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(message),
          showCloseIcon: true,
        ),
      );
    }

    void pop() {
      Navigator.of(context).pop();
    }

    void orderItems() async {
      // Get the items from the cart
      final items = cartController.getCartItems().map((item) {
        return {
          'itemId': item.id,
          'name': item.name,
          'quantity': item.quantity,
          'price': item.price,
          'category': item.category,
        };
      }).toList();

      // If there are no items in the cart, don't place the order
      if (items.isEmpty) {
        showSnackbar(
            'No items in the cart. Add items before placing an order.');
        return;
      }

      final userId = ref.watch(userSicProvider);
      final userName = ref.watch(userNameProvider);
      final timeStamp = Timestamp.fromDate(DateTime.now());
      final totalAmount = cartController.getTotalPayment();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
          );
        },
      );
      try {
        // Start a Firestore transaction
        // Add the order to the Orders collection
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          DocumentReference orderRef =
              FirebaseFirestore.instance.collection('orders').doc();

          transaction.set(orderRef, {
            'name': userName,
            'userId': userId,
            'timestamp': timeStamp,
            'items': items,
            'totalAmount': totalAmount,
            'status': 'pending',
          });

          final orderId = orderRef.id;

          DocumentReference orderQueueRef =
              FirebaseFirestore.instance.collection('ordersQueue').doc(orderId);

          transaction.set(orderQueueRef, {
            'orderId': orderId,
            'status': 'pending',
            'timeStamp': timeStamp,
          });
        });

        setState(() {
          cartController.clearCart();
        });
        pop();
        showSnackbar('Order placed successfully');
      } catch (error) {
        // Transaction failed
        String errorMessage;
        if (error is FirebaseException) {
          switch (error.code) {
            case 'permission-denied':
              errorMessage = 'You do not have permission to place an order.';
              break;
            case 'network-error':
              errorMessage = 'A network error occurred. Please try again.';
              break;
            default:
              errorMessage = 'An unexpected error occurred. Please try again.';
              break;
          }
        } else {
          errorMessage = 'An unexpected error occurred. Please try again.';
        }

        showSnackbar(errorMessage);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text.rich(
          TextSpan(
            text: 'Check ',
            style: const TextStyle(
              fontFamily: 'NauticalPrestige',
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'Out',
                style: TextStyle(
                  fontFamily: 'NauticalPrestige',
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Help'),
                ),
              ),
              const PopupMenuItem(
                child: ListTile(
                  leading: Icon(Icons.question_answer),
                  title: Text('FAQ'),
                ),
              ),
            ],
          )
        ],
      ),
      body: cartItemsLength
          ? Center(
              child: Container(
                height: screenHeight / 3,
                width: screenHeight / 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/empty_cart.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      // elevation: 5,
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartData.items.length,
                                  itemBuilder: (context, index) {
                                    final data = cartData.items[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 0,
                                      ),
                                      child: SizedBox(
                                        height: screenHeight / 15,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: screenwidth / 3,
                                                  child: Text(
                                                    data.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: "Inter",
                                                      // fontWeight:
                                                      // FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // const SizedBox(width: 40),
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(),
                                                // color: Colors.amber,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  IconButton(
                                                    icon: data.quantity == 1
                                                        ? Icon(
                                                            Icons
                                                                .delete_rounded,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .error,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .remove_circle_sharp,
                                                          ),
                                                    iconSize: 15,
                                                    onPressed: () {
                                                      setState(
                                                        () {
                                                          if (data.quantity >
                                                              1) {
                                                            cartController
                                                                .updateItem(
                                                                    data.id,
                                                                    data.quantity -
                                                                        1);
                                                          } else {
                                                            cartController
                                                                .removeItem(
                                                                    data.id);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  Text(
                                                    '${data.quantity}', // This is now a dynamic value representing the current number of items
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                      fontFamily: "Inter",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.add_circle_sharp,
                                                    ),
                                                    iconSize: 15,
                                                    onPressed: () {
                                                      setState(() {
                                                        cartController
                                                            .updateItem(
                                                          data.id,
                                                          data.quantity + 1,
                                                        );
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '₹${data.price * data.quantity}', //dynamic
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: "Inter",
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const DottedLine(),
                                ListTile(
                                  title: const Text('Add more items'),
                                  trailing: IconButton(
                                    icon: const Icon(
                                        Icons.add_circle_outline_outlined),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 20,
                        ),
                        child: Text(
                          'Bill Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'IBMPLexMono',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Card(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: SizedBox(
                              // height: 100,
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Item Total',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        '₹${cartController.getItemTotalPrice()}',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const DottedLine(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: SizedBox(
                                      width: screenwidth / 1.5,
                                      child: const Text(
                                        'Order can be cancel within 1 minute of placing order',
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Platform fee',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      Text(
                                        '₹${cartController.getPlatformFee()}', //dynamic
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const DottedLine(),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 30,
                                      bottom: 10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'To Pay',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Inter',
                                          ),
                                        ),
                                        Text(
                                          '₹${cartController.getTotalPayment()}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
      bottomNavigationBar: cartItemsLength
          ? null
          : ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30.0)),
              child: BottomAppBar(
                color: Theme.of(context)
                    .colorScheme
                    .secondaryContainer
                    .withOpacity(0.6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenwidth / 2.5,
                      child: const Text(
                        'Amount:',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'IBMPlexMono',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '₹${cartController.getTotalPayment()}', // for now but will be amount wait for it
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    FilledButton.tonal(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).colorScheme.onPrimary),
                      ),
                      onPressed: orderItems,
                      child: Text(
                        'Order',
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
