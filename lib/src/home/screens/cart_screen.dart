import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text(
              'Check Out',
              style: TextStyle(
                fontFamily: 'IBMPLexMono',
                fontWeight: FontWeight.bold,
                fontSize: 25,
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 5,
              ),
              child: Card(
                elevation: 5,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      // height: screenHeight / 2 * (3 / 3),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: 3,
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
                                              child: const Text(
                                                'Kulfi', // dynamic name
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  // fontFamily: "IBMPLexMono",
                                                  // fontWeight: FontWeight.bold,
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
                                                onPressed: () {
                                                  // Decrease the number of items in the cart
                                                },
                                              ),
                                              const Text(
                                                '1', // This should be a dynamic value representing the current number of items
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontFamily: "IBMPLexMono",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                iconSize: 15,
                                                onPressed: () {
                                                  // Increase the number of items in the cart
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Text(
                                          '₹99', //dynamic
                                          style: TextStyle(
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
                            const Divider(indent: 20, endIndent: 20),
                            ListTile(
                              title: const Text('Add more items'),
                              trailing: IconButton(
                                icon: const Icon(
                                    Icons.add_circle_outline_outlined),
                                onPressed: () {
                                  // Add more items to the cart
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(),
        ],
      ),
    );
  }
}
