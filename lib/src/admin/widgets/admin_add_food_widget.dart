import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sorasummit/providers/food_data_provider.dart';
import 'package:sorasummit/src/admin/screens/add_food_item_screen.dart';

class AdminAddFoodWidget extends ConsumerStatefulWidget {
  const AdminAddFoodWidget({super.key});

  @override
  ConsumerState<AdminAddFoodWidget> createState() => _AdminAddFoodWidgetState();
}

class _AdminAddFoodWidgetState extends ConsumerState<AdminAddFoodWidget> {
  @override
  Widget build(BuildContext context) {
    var foodItemDetails =
        ref.watch(foodItemNameAndSellingPriceAndImageProvider);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),

          Center(
            child: Text(
              '₹ 1,000', // dynamic on the number of items sold.
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.06,
                fontFamily: 'IBMPlexMono',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),

          Center(
            child: Text(
              'revenue this month',
              maxLines: 3,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontFamily: 'IBMPlexMono',
              ),
            ),
          ),

          Center(
              child: Text(
            '+₹800 from last month', // use richText
            maxLines: 3,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.02,
              fontFamily: 'IBMPlexMono',
            ),
          )),

          const SizedBox(
            height: 20,
          ),

          //FilledButton saying add items
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AddFoodItemScreen.routeName);
              },
              icon: const Icon(Icons.add),
              label: Text(
                'Add Items',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontFamily: 'IBMPlexMono',
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 30,
          ),

          //Text saying items
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              'Current Menu',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.02,
                fontFamily: 'IBMPlexMono',
              ),
            ),
          ),

          //List of items
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: foodItemDetails.length,
            itemBuilder: (context, index) {
              var listItem = foodItemDetails[index];
              return ListTile(
                leading: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      //random image
                      image: NetworkImage(listItem['imageUrl']),
                      fit: BoxFit.cover,
                    ),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(
                  '${listItem['name']}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontFamily: 'IBMPlexMono',
                  ),
                ),
                trailing: Text(
                  '₹ ${listItem['sellingPrice']}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontFamily: 'IBMPlexMono',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
