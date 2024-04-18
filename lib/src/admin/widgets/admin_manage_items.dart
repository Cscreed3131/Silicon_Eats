import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sorasummit/providers/food_data_provider.dart';

class AdminManageItemsmWidget extends ConsumerStatefulWidget {
  const AdminManageItemsmWidget({super.key});

  @override
  ConsumerState<AdminManageItemsmWidget> createState() =>
      _AdminManageItemsmWidgetState();
}

class _AdminManageItemsmWidgetState
    extends ConsumerState<AdminManageItemsmWidget> {
  @override
  Widget build(BuildContext context) {
    final foodData = ref.watch(foodItemStreamProvider);
    // in near future modify this method to something meaning full.
    void deleteDocumentAndImage() async {
      String documentIdToDelete = 'tv5QgF7MK9uc4TtyJlhy';
      var firestore = FirebaseFirestore.instance;
      var firebaseStorage = FirebaseStorage.instance;
      await firestore.collection('foodItems').doc(documentIdToDelete).delete();
      await firestore
          .collection('foodItemAvailability')
          .doc(documentIdToDelete)
          .delete();
      var imageRef = firebaseStorage.ref().child('foodItems/Luffy.jpg');
      await imageRef.delete();
    }

    return foodData.when(
      data: (data) {
        return Column(
          children: [
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

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Items',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontFamily: 'IBMPlexMono',
                    ),
                  ),
                  Text(
                    'Available',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * 0.02,
                      fontFamily: 'IBMPlexMono',
                    ),
                  ),
                ],
              ),
            ),

            //List of items
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 50,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var listItem = data[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.height * 0.05,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            //random image
                            image:
                                CachedNetworkImageProvider(listItem.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(
                          width: 10), // Add some spacing between the widgets
                      Expanded(
                        child: Text(
                          listItem.name,
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.height * 0.02,
                            fontFamily: 'IBMPlexMono',
                          ),
                        ),
                      ),
                      Checkbox(
                        value: listItem.available,
                        onChanged: (bool? newValue) {
                          // write logic here
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  deleteDocumentAndImage();
                },
                child: const Text('Done')),
          ],
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text('Oops'),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
