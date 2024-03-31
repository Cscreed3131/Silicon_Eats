import 'package:flutter/material.dart';
// import 'package:sorasummit/screens/home/widgets/app_drawer_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String> categoryImages = {
    "All": "assets/images/dosa.jpeg", // replace with your image url
    "Counter 1": "assets/images/dosa.jpeg", // replace with your image url
    "Counter 2": "assets/images/dosa.jpeg", // replace with your image url
    "Counter 3": "assets/images/dosa.jpeg", // replace with your image url
    "Counter 4": "assets/images/dosa.jpeg", // replace with your image url
  };
  int selectedCategoryIndex = 0;
  List<String> categories = [
    "All",
    "Counter 1",
    "Counter 2",
    "Counter 3",
    "Counter 4"
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var font20 = height / 27.6;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: height * 0.1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text(
          'Silicon Eats',
          style: TextStyle(fontFamily: 'NauticalPrestige', fontSize: 50),
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
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.zero,
                    title: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02),
                        const Center(
                          child: Text(
                            'Silicon Eats',
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontFamily: 'NauticalPrestige',
                              fontSize: 40,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ProfileDialog(), // this will be widget which will show user profile
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // this will be a textbutton.
                            Text(
                              'Privacy Policy',
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const CircleAvatar(
                              radius: 1,
                              foregroundColor: Colors.grey,
                              backgroundColor: Colors.grey,
                            ),
                            const SizedBox(
                              width: 10,
                            ),

                            // this will also be a textbutton.
                            Text(
                              'Terms of Service',
                              style: TextStyle(color: Colors.grey.shade800),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
            icon: const Icon(
              Icons.account_circle,
              color: Colors.black87,
              size: 30,
            ),
          ),
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
                            'Hello Anubhav,\n', // this will be dynamically fetched from the database.
                        style: TextStyle(
                            fontSize: font20,
                            fontFamily: "IBMPlexMono",
                            fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
