import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/providers/order_queue_provider.dart';
import 'package:sorasummit/src/home/widgets/current_orders_widget.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});
  static const routeName = '/orders-screen';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text.rich(
          TextSpan(
            text: 'Order ',
            style: const TextStyle(
              fontFamily: 'NauticalPrestige',
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'History',
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer(
                builder: (context, ref, _) {
                  final data = ref.watch(userCurrentlyProcessingOrdersProvider);
                  return data.when(
                    data: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Currently Preparing',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'IBMPLexMono',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          data.isNotEmpty
                              ? SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    child: ListView.builder(
                                      // scrollDirection: Axis.horizontal,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        final item = data[index]!;
                                        return CurrentOrdersWidget(
                                          items: item.items,
                                          orderId: item.orderId,
                                          status: item.status,
                                          timeStamp: item.timeStamp,
                                        );
                                      },
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    height: MediaQuery.sizeOf(context).height *
                                        0.33,
                                    width: MediaQuery.sizeOf(context).height *
                                        0.33,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/empty_cart.jpg'),
                                          fit: BoxFit.cover),
                                    ),
                                    // child: Text('Order Something now +'),
                                  ),
                                ),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(
                        child: Text("Can't load past orders"),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    },
                  );
                },
              ),
              Consumer(
                builder: (context, ref, _) {
                  final data = ref.watch(userPastOrdersProvider);
                  return data.when(
                    data: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Past Orders',
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'IBMPLexMono',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (data.isNotEmpty)
                            SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                child: ListView.builder(
                                  // scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    final item = data[index]!;
                                    return CurrentOrdersWidget(
                                      items: item.items,
                                      orderId: item.orderId,
                                      status: item.status,
                                      timeStamp: item.timeStamp,
                                    );
                                  },
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                    error: (error, stackTrace) {
                      return const Center(
                        child: Text("Can't load past orders"),
                      );
                    },
                    loading: () {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    },
                  );
                  // print(data[0].items);
                },
              ),

              // wrap this with a sized box and then hide this if no orders are being prepared.
            ],
          ),
        ),
      ),
    );
  }
}
