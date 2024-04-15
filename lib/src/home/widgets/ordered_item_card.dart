import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends ConsumerStatefulWidget {
  final String orderId;
  final String status;
  final DateTime timeStamp;
  final String userId;
  final List items;
  final String name;
  const OrderItemCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.timeStamp,
    required this.userId,
    required this.items,
    required this.name,
  });

  @override
  ConsumerState<OrderItemCard> createState() => OrderItemCardState();
}

class OrderItemCardState extends ConsumerState<OrderItemCard> {
  void updateStatus(String orderId) {
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference orderQueueRef =
          FirebaseFirestore.instance.collection('ordersQueue').doc(orderId);
      DocumentReference orderRef =
          FirebaseFirestore.instance.collection('orders').doc(orderId);
      transaction.update(orderQueueRef, {'status': 'Done'});
      transaction.update(orderRef, {'status': 'Done'});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Name: ',
                          style: TextStyle(
                            fontFamily: 'IBMPLexMono',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Sic: ',
                          style: TextStyle(
                            fontFamily: 'IBMPLexMono',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.userId,
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text.rich(
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
                  Text.rich(
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
                          text: DateFormat('h:mm a, EEEE, MMM d,')
                              .format(widget.timeStamp),
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status: ',
                        style: TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            widget.status == 'pending'
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        onPressed: () {
                          updateStatus(widget.orderId);
                        },
                        child: Text(
                          widget.status,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const SizedBox(
              //   width: 100,
              // ),
              Card(
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Item Name'),
                    ),
                    DataColumn(
                      label: Text('Quantity'),
                    ),
                    DataColumn(
                      label: Text('Price'),
                    ),
                  ],
                  rows: widget.items.map<DataRow>((item) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(
                          Text(
                            item['name'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            item['quantity'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '₹${item['price'].toString()}',
                          ),
                        ),

                        // Add more DataCell here for other properties in the map
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
