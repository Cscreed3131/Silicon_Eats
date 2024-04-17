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
        title: const Text(
          'Order History',
          style: TextStyle(
            fontFamily: 'IBMPLexMono',
            fontWeight: FontWeight.bold,
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
                  final data = ref.watch(userOrdersProvider);
                  // print(data[0].items);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Currently Preparing',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'IBMPLexMono',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        // height: MediaQuery.of(context).size.height / 5,
                        // width: MediaQuery.of(context).size.width / 1.335,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: data.length,
                            // itemExtent: 10,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return CurrentOrdersWidget(items: item.items);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
              // wrap this with a sized box and then hide this if no orders are being prepared.
            ],
          ),
        ),
      ),
    );
  }
}
