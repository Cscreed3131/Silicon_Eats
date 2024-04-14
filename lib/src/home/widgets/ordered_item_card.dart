import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class OrderItemCard extends ConsumerStatefulWidget {
  final String orderId;
  final String status;
  final DateTime timeStamp;
  final String userId;
  final List items;
  const OrderItemCard({
    super.key,
    required this.orderId,
    required this.status,
    required this.timeStamp,
    required this.userId,
    required this.items,
  });

  @override
  ConsumerState<OrderItemCard> createState() => OrderItemCardState();
}

class OrderItemCardState extends ConsumerState<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    // final shortestSide = MediaQuery.of(context).size.shortestSide < 550;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
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
                    SizedBox(
                      child: Text.rich(
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
                    ),
                  ],
                ),
                // const SizedBox(
                //   width: 100,
                // ),
                SizedBox(
                  child: DataTable(
                    // columnSpacing: 20,
                    // headingRowColor: MaterialStateColor.resolveWith(
                    //     (states) => Colors.grey[200]!),
                    // headingTextStyle: const TextStyle(
                    //     fontWeight: FontWeight.bold, fontSize: 16),
                    // dataRowColor: MaterialStateColor.resolveWith(
                    //     (states) => Colors.white),
                    // dataTextStyle: const TextStyle(fontSize: 14),
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
                          DataCell(Text(item['name'].toString())),
                          DataCell(Text(item['quantity'].toString())),
                          DataCell(Text(item['price'].toString())),

                          // Add more DataCell here for other properties in the map
                        ],
                      );
                    }).toList(),
                  ),
                ),
                // const SizedBox(
                //   width: 300,
                // ),
                SizedBox(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Status: ',
                          style: TextStyle(
                            fontFamily: 'IBMPLexMono',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: widget.status,
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
          ),
        ),
      ),
    );
  }
}
