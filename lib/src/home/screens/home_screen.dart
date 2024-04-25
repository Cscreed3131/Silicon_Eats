import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sorasummit/providers/food_data_provider.dart';
import 'package:sorasummit/providers/user_data_provider.dart';
import 'package:sorasummit/src/home/screens/announcement_screen.dart';
import 'package:sorasummit/src/home/widgets/cart_item_button.dart';
import 'package:sorasummit/src/home/widgets/food_card.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final font20 = screenHeight / 27.6;
    final userNameFromProvider = ref.watch(userNameProvider);
    final foodIteProviderCached = ref.watch(cachedFoodItemProvider);
    // final cartDataProvider = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.065,
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        title: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text:
                    'Silicon ', // this will be dynamically fetched from the database.
                style: TextStyle(
                  fontSize: 50,
                  fontFamily: "NauticalPrestige",
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: 'Eats',
                style: TextStyle(
                  fontSize: 50, // replace with your font size
                  fontWeight: FontWeight.bold,
                  fontFamily: "NauticalPrestige",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.black87,
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pushNamed(AnnouncementScreen.routeName);
            },
          ),
          const CartButton(),
          const ProfileDialogBox(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
              child: Container(
                alignment: Alignment.topLeft,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20), // border radius of 20
                  // color: Theme.of(context).colorScheme.secondary,
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello ${userNameFromProvider.split(' ')[0]},\n',
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
              height: screenHeight / 10.5,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: categoryImages.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                addRepaintBoundaries: false,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: FilterChip(
                      showCheckmark: false,
                      side: BorderSide.none,
                      selectedColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.9),
                      selected: selectedCategoryIndex == index,
                      onSelected: (bool value) {
                        setState(() {
                          selectedCategoryIndex = index;
                        });
                      },
                      label: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 50, // Adjust this height as needed
                            width: 50, // Adjust this width as needed
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
              height: 15,
            ),
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                itemCount: foodIteProviderCached.length,
                shrinkWrap: true,
                key: ValueKey<int>(selectedCategoryIndex),
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = foodIteProviderCached[index];
                  if (selectedCategoryIndex == 0 ||
                      item.category == categories[selectedCategoryIndex]) {
                    return FoodCard(
                      index: index,
                      foodData: foodIteProviderCached,
                      font20: font20,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
              // child: ref.watch(foodItemStreamProvider).when(
              //   data: (data) {

              //   },
              //   error: (error, stackTrace) {
              //     return const Center(
              //       child: Text('unable to load food items'),
              //     );
              //   },
              //   loading: () {
              //     return const Center(
              //       child: CircularProgressIndicator.adaptive(),
              //     );
              //   },
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
