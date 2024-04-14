import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/providers/order_queue_provider.dart';
// import 'package:sorasummit/providers/orders_data_provider.dart';
import 'package:sorasummit/src/home/widgets/ordered_item_card.dart';
import 'package:sorasummit/src/home/widgets/profile_dialog_box.dart';

class StaffHomeScreen extends ConsumerStatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  ConsumerState<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends ConsumerState<StaffHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    final shortestSide = MediaQuery.of(context).size.shortestSide < 550;
    final font20 = screenHeight / 27.6;
    final data = ref.watch(orderToOrderIdProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: shortestSide ? screenHeight * 0.1 : screenHeight * 0.06,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    'Silicon ', // this will be dynamically fetched from the database.
                style: TextStyle(
                  fontSize: font20 + 20,
                  fontFamily: "NauticalPrestige",
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Eats',
                style: TextStyle(
                  fontSize: font20 + 20, // replace with your font size
                  fontWeight: FontWeight.bold,
                  fontFamily: "NauticalPrestige",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: const [
          ProfileDialogBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: SizedBox(
                child: Text(
                  "Today's Orders Queue",
                  style: TextStyle(
                    fontFamily: 'IBMPLexMono',
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              // height: screenHeight,
              width: screenwidth,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenwidth / 25, vertical: 5),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: data.length,
                  // itemExtent: 10,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return OrderItemCard(
                      orderId: item.orderId,
                      status: item.status,
                      timeStamp: item.timeStamp,
                      items: item.items,
                      userId: item.userId,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
