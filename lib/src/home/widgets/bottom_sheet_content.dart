import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BottomSheetContent extends StatefulWidget {
  final int initialCount;
  final String name;
  final String image;
  final String category;
  final double price;
  final String description;
  final Function(int) onCountChanged;

  const BottomSheetContent({
    super.key,
    required this.initialCount,
    required this.onCountChanged,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    required this.description,
  });

  @override
  State<BottomSheetContent> createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  int count = 0;

  @override
  void initState() {
    super.initState();
    count = widget.initialCount;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final font30 = screenHeight * 0.035;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.005,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            elevation: 5,
            child: Container(
              height: screenHeight * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(widget.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'IBMPlexMono',
                    fontSize: font30,
                    fontWeight: FontWeight.bold,
                    // color: textColor,
                  ),
                ),
                Text(
                  widget.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 130,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filled(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          if (count > 1) {
                            count--;
                            widget.onCountChanged(count);
                          } else {
                            Navigator.of(context).pop();
                          }
                        });
                      },
                      icon: Icon(
                        Icons.remove,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontFamily: 'IBMPlexMono',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        setState(() {
                          count++;
                          widget.onCountChanged(count);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      icon: Icon(
                        Icons.add,
                        color: Theme.of(context).colorScheme.background,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fastfood,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  label: Text(
                    'Add item ₹${(widget.price * count).round()}',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.background,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
