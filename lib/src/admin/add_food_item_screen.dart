import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorasummit/src/admin/widgets/image_picker_widget.dart';

class AddFoodItemScreen extends StatelessWidget {
  const AddFoodItemScreen({super.key});
  static const routeName = '/add-food-item';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Food Item',
          style: TextStyle(fontFamily: 'IBMPlexMono'),
        ),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: BuildForm(),
      ),
    );
  }
}

class BuildForm extends ConsumerStatefulWidget {
  const BuildForm({super.key});

  @override
  ConsumerState<BuildForm> createState() => _BuildFormState();
}

class _BuildFormState extends ConsumerState<BuildForm> {
  List<String> categories = [
    "Breakfast",
    "North Indian",
    "South Indian",
    "Beverages",
    "Desserts",
  ];

  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String name = '';
  String description = '';
  double price = 0;
  String category = '';
  double costPrice = 0;
  double sellingPrice = 0;

  final _descriptionFocusNode = FocusNode();
  final _costPriceFocusNode = FocusNode();
  final _sellingPriceFocusNode = FocusNode();

  Future<bool> _submit(int id) async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }
    _formKey.currentState!.save();
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Please select a food item image'),
        ),
      );
      return false;
    }
    DateTime now = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(now);
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child('foodItems').child('$name.jpg');
      await storageRef.putFile(_selectedImage!);
      final imageUrl = await storageRef.getDownloadURL();
      FirebaseFirestore.instance.collection('foodItems').doc().set({
        'added_by': FirebaseAuth.instance.currentUser!.uid,
        'date_and_time': timestamp,
        'name': name,
        'description': description,
        'costPrice': costPrice,
        'sellingPrice': sellingPrice,
        'category': category,
        'imageUrl': imageUrl,
        'available': true,
        'id': 1,
      });
      return true;
    } on FirebaseException catch (_) {
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionFocusNode.dispose();
    _costPriceFocusNode.dispose();
    _sellingPriceFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int id = 1;
    // ref.watch(foodItemStreamProvider).when(
    //     data: (data) {
    //       id = data.length;
    //     },
    //     error: (error, stackTrace) {
    //       print(error);
    //       print(stackTrace);
    //       id = null;
    //       ScaffoldMessenger.of(context).showSnackBar(
    //           const SnackBar(content: Text("Can't set id of the food item.")));
    //     },
    //     loading: () {});
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ImagePickerWidget(
              onPickImage: (pickedImage) {
                _selectedImage = pickedImage;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                if (value.split(RegExp(r'\s+')).length >= 3) {
                  return 'Please enter a name in less than 3 words';
                }
                if (value.isNotEmpty) {
                  RegExp specialCharacters = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
                  if (specialCharacters.hasMatch(value)) {
                    return 'Name cannot contain special characters';
                  }
                }
                return null;
              },
              onSaved: (newValue) {
                name = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              focusNode: _descriptionFocusNode,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_costPriceFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description of item';
                }
                if (value.split(RegExp(r'\s+')).length <= 5) {
                  return 'Please enter a description which has more than 5 words ';
                }

                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onSaved: (newValue) {
                description = newValue!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Cost Price',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              focusNode: _costPriceFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_sellingPriceFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a cost price';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Please enter a valid positive number';
                }
                if (value.isNotEmpty) {
                  RegExp specialCharacters = RegExp(r'[!@#\$%^&*()?":{}|<>]');
                  if (specialCharacters.hasMatch(value)) {
                    return 'Cost price cannot contain special characters';
                  }
                }
                return null;
              },
              onSaved: (newValue) {
                costPrice = double.tryParse(newValue!)!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Selling Price',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              focusNode: _sellingPriceFocusNode,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a selling price';
                }
                if (double.tryParse(value) == null ||
                    double.parse(value) <= 0) {
                  return 'Please enter a valid positive number';
                }
                if (value.isNotEmpty) {
                  RegExp specialCharacters = RegExp(r'[!@#\$%^&*()?":{}|<>]');
                  if (specialCharacters.hasMatch(value)) {
                    return 'Selling price cannot contain special characters';
                  }
                }
                return null;
              },
              onSaved: (newValue) {
                sellingPrice = double.tryParse(newValue!)!;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            //using this for reading barcode and displaying in the TextFormField
            // TextFormField(
            //   decoration: InputDecoration(
            //     labelText: 'Barcode',
            //     alignLabelWithHint: true,
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(20),
            //     ),
            //   ),
            //   readOnly: true,
            //   onTap: () async {
            //     String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
            //       '#ff6666',
            //       'Cancel',
            //       true,
            //       ScanMode.BARCODE,
            //     );
            //     if (barcodeScanRes != '-1') {
            //       _nameController.text = barcodeScanRes;
            //     }
            //   },
            // ),
            Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: categories
                  .map(
                    (category) => ChoiceChip(
                      label: Text(category),
                      selected: this.category == category,
                      onSelected: (bool selected) {
                        setState(() {
                          this.category = category;
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () async {
                      await _submit(id)
                          ? {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Uploading was successful'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              ),
                              // Navigator.of(context)
                              //     .pushReplacementNamed(FoodScreen.routeName),
                            }
                          : ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Uploading was Unsuccessful'),
                              ),
                            );
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
