import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends ConsumerStatefulWidget {
  final String orderId;
  final String status;
  final DateTime timeStamp;
  const OrderItemCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.timeStamp,
  });

  @override
  ConsumerState<OrderItemCard> createState() => OrderItemCardState();
}

class OrderItemCardState extends ConsumerState<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final shortestSide = MediaQuery.of(context).size.shortestSide < 550;
    return Card(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          height: screenHeight / 10,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'OrderId: ',
                            style: TextStyle(
                              fontFamily: 'IBMPLexMono',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.orderId,
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Time: ',
                            style: TextStyle(
                              fontFamily: 'IBMPLexMono',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: DateFormat('h:mm a, EEEE, MMMM d,yyyy')
                                .format(widget.timeStamp),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: Text(widget.status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
