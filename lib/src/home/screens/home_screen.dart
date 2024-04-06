import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sorasummit/providers/food_data_provider.dart';
import 'package:sorasummit/providers/user_data_provider.dart';
import 'package:sorasummit/src/home/widgets/food_item_widget.dart';
import 'package:sorasummit/src/home/widgets/profile_dialog_box.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Map<String, String> categoryImages = {
    "All": "assets/images/aloo mattar.jpeg",
    "Counter 1": "assets/images/Butter Paneer.jpeg",
    "Counter 2": "assets/images/Thandai Kulfi.jpeg",
    "Counter 3": "assets/images/dosa.jpeg",
    "Counter 4": "assets/images/dosa.jpeg",
  };
  int selectedCategoryIndex = 0;
  List<String> categories = [
    "All",
    "Counter 1",
    "Counter 2",
    "Counter 3",
    "Counter 4",
  ];

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final font20 = height / 27.6;

    final userNameFromProvider = ref.watch(userNameProvider);
    final foodItemDataProvider =
        ref.watch(foodItemNameAndSellingPriceAndImageProvider);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text:
                    'Silicon ', // this will be dynamically fetched from the database.
                style: TextStyle(
                  fontSize: font20 + 20,
                  fontFamily: "NauticalPrestige",
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Eats',
                style: TextStyle(
                  fontSize: font20 + 20, // replace with your font size
                  fontWeight: FontWeight.bold,
                  fontFamily: "NauticalPrestige",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // all this will contain seperate widgets which will lead to seperate pages....
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black87,
            iconSize: 30,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.fastfood),
            color: Colors.black87,
            iconSize: 30,
            onPressed: () {},
          ),
          const ProfileDialogBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // border radius of 20
                  // color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text:
                            'Hello ${userNameFromProvider.split(' ')[0]},\n', // this will be dynamically fetched from the database.
                        style: TextStyle(
                          fontSize: font20,
                          fontFamily: "IBMPlexMono",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'What do you want to eat today?',
                        style: TextStyle(
                          fontSize:
                              font20 * 0.60, // replace with your font size
                          fontFamily: "IBMPlexMono",
                          color: Colors.black.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: height * 0.11,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categoryImages.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                addRepaintBoundaries: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: FilterChip(
                      showCheckmark: false,
                      side: BorderSide.none,
                      selectedColor: Theme.of(context).colorScheme.secondary,
                      selected: selectedCategoryIndex == index,
                      onSelected: (bool value) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      label: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 70, // Adjust this height as needed
                            width: 70, // Adjust this width as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                categoryImages.values.toList()[index],
                                fit: BoxFit.cover,
                              ),
                            ), // use the map to get the image url
                          ),
                          Text(categories[index]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            MediaQuery.removePadding(
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: foodItemDataProvider.length,
                itemBuilder: (context, index) {
                  final listItem = foodItemDataProvider[index];
                  if (selectedCategoryIndex == 0 ||
                      listItem['category'] ==
                          categories[selectedCategoryIndex]) {
                    return FoodItemWidget(
                      height: height,
                      listItem: listItem,
                      width: width,
                      font20: font20,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
