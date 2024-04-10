import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final itemMap = {
    'item 1': 500,
    'item 2': 400,
    'item 3': 300,
    'item 4': 200,
    'item 5': 100,
  };

  Map<String, int> itemCount = {};

  @override
  void initState() {
    super.initState();
    itemCount = Map.fromEntries(itemMap.entries.map((e) => MapEntry(e.key, 1)));
  }

  void _incrementCount(String itemName) {
    setState(() {
      itemCount[itemName] = itemCount[itemName]! + 1;
    });
  }

  void _decrementCount(String itemName) {
    setState(() {
      if (itemCount[itemName]! > 0) {
        itemCount[itemName] = itemCount[itemName]! - 1;
      }
    });
  }

  double calculateItemTotal() {
    double total = 0;
    itemMap.forEach((key, value) {
      total += value * itemCount[key]!;
    });
    return total;
  }

  double calculateGST() {
    double total = calculateItemTotal();
    return total * 0.18;
  }

  double getDeliveryPrice() {
    double kms = 10;
    double fixedPrice = 30;
    return kms * fixedPrice;
  }

  int calulateAmount() {
    double gst = calculateGST();
    double total = calculateItemTotal();
    double delivery = getDeliveryPrice();
    double result = gst + total + delivery + 9.9;
    return result.round();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Check Out',
          style: TextStyle(
            fontFamily: 'IBMPlexMono',
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Card(
                // elevation: 5,
                child: Column(
                  children: [
                    SizedBox(
                      // height: screenHeight / 2 * (3 / 3),
                      width: double.infinity,
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemMap.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 5,
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
                                              itemMap.entries
                                                  .elementAt(index)
                                                  .key,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: "IBMPLexMono",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // const SizedBox(width: 40),
                                      Container(
                                        height: 40,
                                        // width: 110,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              // color: Colors.black,
                                              // width: 2.0,
                                              ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove),
                                              iconSize: 15,
                                              onPressed: () => _decrementCount(
                                                  itemMap.entries
                                                      .elementAt(index)
                                                      .key),
                                            ),
                                            Text(
                                              '${itemCount[itemMap.entries.elementAt(index).key]}', // This should be a dynamic value representing the current number of items
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontFamily: "IBMPLexMono",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add),
                                              iconSize: 15,
                                              onPressed: () => _incrementCount(
                                                  itemMap.entries
                                                      .elementAt(index)
                                                      .key),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '₹${itemMap.entries.elementAt(index).value}', //dynamic
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: "IBMPLexMono",
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
                              icon:
                                  const Icon(Icons.add_circle_outline_outlined),
                              onPressed: () {
                                // Add more items to the cart
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
                    vertical: 10,
                  ),
                  child: Card(
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Item Total',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'IBMPLexMono',
                                  ),
                                ),
                                Text(
                                  '₹${calculateItemTotal()}', //dynamic
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: "IBMPLexMono",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const DottedLine(),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: SizedBox(
                                width: screenwidth / 1.5,
                                child: const Text(
                                  'Order can be cancel within 1 minute of placing order',
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Platform fee',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'IBMPLexMono',
                                    ),
                                  ),
                                  Text(
                                    '₹9.9', //dynamic
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: "IBMPLexMono",
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
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
                                      fontFamily: 'IBMPLexMono',
                                    ),
                                  ),
                                  Text(
                                    '₹${calulateAmount()}', //dynamic
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: "IBMPLexMono",
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: screenwidth / 2.5,
              child: const Text(
                'Amount:',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'IBMPLexMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '₹${calulateAmount()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            FilledButton.tonal(
              child: const Text(
                'Order',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
