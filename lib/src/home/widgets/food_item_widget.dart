import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FoodItemWidget extends StatefulWidget {
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
  State<FoodItemWidget> createState() => _FoodItemWidgetState();
}

class _FoodItemWidgetState extends State<FoodItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: widget.height * 0.15,
          width: widget.height * 0.15,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(20),
          // ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: '${widget.listItem['imageUrl']}',
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: widget.width * 0.30,
          height: widget.height * 0.15,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${widget.listItem['name']}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'IBMPlexMono',
                  fontSize: widget.font20 * 0.6,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.listItem['category']}", //dynamic category
                style: TextStyle(
                  fontFamily: 'IBMPlexMono',
                  fontSize: widget.font20 * 0.4,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "₹ ${widget.listItem['sellingPrice']}", //Dynamic price
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
        const SizedBox(width: 10),
        SizedBox(
          height: widget.height * 0.15,
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
    );
  }
}
