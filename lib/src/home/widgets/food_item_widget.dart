import 'package:flutter/material.dart';

class FoodItemWidget extends StatelessWidget {
  const FoodItemWidget({
    super.key,
    required this.height,
    required this.listItem,
    required this.width,
    required this.font20,
  });

  final double height;
  final Map<String, dynamic> listItem;
  final double width;
  final double font20;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.outline,
        // ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: height * 0.15,
            width: height * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: NetworkImage('${listItem['imageUrl']}'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: width * 0.30,
            height: height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${listItem['name']}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: font20 * 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${listItem['category']}", //dynamic category
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: font20 * 0.4,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "₹ ${listItem['sellingPrice']}", //Dynamic price
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontWeight: FontWeight.bold,
                    fontSize: font20 * 0.7,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: height * 0.15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonal(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
