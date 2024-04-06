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
        color: Theme.of(context).colorScheme.primaryContainer,
        // border: Border.all(
        //   color: Theme.of(context).colorScheme.outline,
        // ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            height: height * 0.15,
            width: height * 0.15,
            decoration: BoxDecoration(
              // border: Border.all(
              //     color: Theme.of(context)
              //         .colorScheme
              //         .outlineVariant),
              borderRadius: BorderRadius.circular(20),
              // this image should be dynamic.
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${listItem['name']}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: font20 * 0.7,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${listItem['category']}", //dynamic category
                  style: const TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "₹ ${listItem['sellingPrice']}", //Dynamic price
                  style: const TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
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
