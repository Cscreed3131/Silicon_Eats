import 'package:flutter/material.dart';

class CurrentOrdersWidget extends StatefulWidget {
  final List items;
  const CurrentOrdersWidget({super.key, required this.items});
  @override
  State<CurrentOrdersWidget> createState() => _CurrentOrdersWidgetState();
}

class _CurrentOrdersWidgetState extends State<CurrentOrdersWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: DataTable(
          columnSpacing: 10,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
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
    );
  }
}
