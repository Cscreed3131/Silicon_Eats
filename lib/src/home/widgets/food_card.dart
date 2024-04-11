import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sorasummit/models/food_item_model.dart';
import 'package:sorasummit/src/home/widgets/bottom_sheet_content.dart';

class FoodCard extends ConsumerStatefulWidget {
  final int index;
  final List<FoodItem> foodData;
  final double font20;
  const FoodCard({
    super.key,
    required this.index,
    required this.foodData,
    required this.font20,
  });

  @override
  ConsumerState<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends ConsumerState<FoodCard> {
  int start = 200;
  int delay = 100;
  bool isAddedoCart = false;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final index = widget.index;
    final data = widget.foodData;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return FadeIn(
      delay: Duration(milliseconds: delay * index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Card(
          child: Container(
            // height: screenHeight * 0.13,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Card(
                  child: Container(
                    height: screenHeight * 0.15,
                    width: screenHeight * 0.15,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                      // border: Border.all(
                      //   color: Theme.of(context).colorScheme.outline,
                      // ),
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          data[index].imageUrl,
                          errorListener: (_) {
                            const Icon(Icons.error);
                          },
                        ), // should be networkImage
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: screenWidth * 0.30,
                  // height: screenHeight * 0.15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        data[index].name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontSize: widget.font20 * 0.6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data[index].category, //dynamic category
                        style: TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontSize: widget.font20 * 0.4,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "₹${data[index].sellingPrice.round()}", //Dynamic price
                        style: TextStyle(
                          fontFamily: 'IBMPlexMono',
                          fontWeight: FontWeight.bold,
                          fontSize: widget.font20 * 0.7,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ),
                // const SizedBox(width: 10),
                SizedBox(
                  height: screenHeight * 0.15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: FilledButton.tonal(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          onPressed: () {
                            setState(
                              () {
                                isAddedoCart = true;
                                count = 1;
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BottomSheetContent(
                                      initialCount: count,
                                      onCountChanged: (newCount) {
                                        setState(() {
                                          count = newCount;
                                        });
                                      },
                                      image: data[index].imageUrl,
                                      name: data[index].name,
                                      category: data[index].category,
                                      description: data[index].description,
                                      price: data[index].sellingPrice,
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Text(
                            'Add',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.background,
                            ),
                          ),
                          // icon: Icon(Icons.fastfood_rounded,
                          //     color: Theme.of(context).colorScheme.background),
                        ),
                      ),
                    ],
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
