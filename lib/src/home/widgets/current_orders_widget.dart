import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentOrdersWidget extends StatefulWidget {
  final List items;
  final String orderId;
  final String status;
  final DateTime timeStamp;
  const CurrentOrdersWidget(
      {super.key,
      required this.items,
      required this.orderId,
      required this.status,
      required this.timeStamp});
  @override
  State<CurrentOrdersWidget> createState() => _CurrentOrdersWidgetState();
}

class _CurrentOrdersWidgetState extends State<CurrentOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.background;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF0C3B2E).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Order id: ',
                    style: TextStyle(
                      color: color,
                      fontFamily: 'IBMPLexMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.orderId,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Status: ',
                    style: TextStyle(
                      color: color,
                      fontFamily: 'IBMPLexMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Timestamp: ',
                    style: TextStyle(
                      color: color,
                      fontFamily: 'IBMPLexMono',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('h:mm a ,EEE , MMM')
                        .format(widget.timeStamp),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Card(
              // surfaceTintColor: const Color(0xFF0C3B2E),
              elevation: 5,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DataTable(
                  columnSpacing: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Text('Item Name'),
                    ),
                    DataColumn(
                      label: Text('Category'),
                    ),
                    DataColumn(
                      numeric: true,
                      label: Text('Quantity'),
                    ),
                    DataColumn(
                      numeric: true,
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
                            item['category'].toString(),
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
                            '₹${item['price'].round().toString()}',
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
