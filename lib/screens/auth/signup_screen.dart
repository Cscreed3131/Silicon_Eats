import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sorasummit/screens/auth/login_screen.dart';

final _firebase = FirebaseAuth.instance;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _isAuthenticating = false;
  var _enteredpassword = '';
  var _enteredSicNumber = '';
  var _enteredbranch = '';
  var _enteredPhoneNumber = '';
  var _enteredStudentYear = '';
  var _enteredUserName = '';
  File? _selectedImage;

  bool showSecondPart = false;

  final _sicFocusNode = FocusNode();
  final _branchFocusNode = FocusNode();
  final _yearFocusNode = FocusNode();
  final _phoneNumberFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  final InputBorder? border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  Future<bool> _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return false;
    }

    // if (_selectedImage == null) {
    //   //promt user to select a image. nessesary
    //   return false;
    // }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });
      await _firebase.createUserWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredpassword,
      );

      // final storageRef = FirebaseStorage.instance
      //     .ref()
      //     .child('user_images')
      //     .child('$_enteredSicNumber.jpg');
      // await storageRef.putFile(_selectedImage!);
      // final imageUrl = await storageRef.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(_enteredSicNumber).set(
        {
          // 'image_url': imageUrl,
          'name': _enteredUserName,
          'sic': _enteredSicNumber,
          'branch': _enteredbranch,
          'year': _enteredStudentYear,
          'phoneNumber': _enteredPhoneNumber,
          'email': _enteredEmail,
          'userId': FirebaseAuth.instance.currentUser!
              .uid, // storing this to easily use the fetch funtion to get the data associated with it
          'userRole': ['student'],
          // 'events_registered': [],
          'cart': {},
          'likedItems': []
        },
      );
      return true;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(error.message ?? 'Authenication failed'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    }
    return false;
  }

  @override
  void dispose() {
    _sicFocusNode.dispose();
    _branchFocusNode.dispose();
    _yearFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Sizes
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final font15 = screenWidth * 0.038;
    final font20 = screenHeight * 0.07;

    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: screenHeight * 0.15,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  'Silicon ', // this will be dynamically fetched from the database.
                              style: TextStyle(
                                fontSize: font20,
                                fontFamily: "NauticalPrestige",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Eats',
                              style: TextStyle(
                                fontSize: font20, // replace with your font size
                                fontWeight: FontWeight.bold,
                                fontFamily: "NauticalPrestige",
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.025,
                      top: screenHeight * 0.025,
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        height: screenHeight * 0.001,
                        fontSize: font20 * 0.7,
                        fontFamily: 'IBMPlexMono',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: !showSecondPart,
                          child: buildFirstPartOfForm(),
                        ),

                        // Second part of the form
                        Visibility(
                          visible: showSecondPart,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            child: buildSecondPartOfForm(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFirstPartOfForm() {
    return Column(
      children: [
        // SizedBox(
        //   height: screenHeight * 0.05,
        // ),
        // UserImagePicker(
        //   onPickImage: (pickedImage) {
        //     _selectedImage = pickedImage;
        //   },
        // ),
        const SizedBox(height: 5),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Name',
            border: border,
          ),
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          // textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_sicFocusNode);
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
          onSaved: (value) {
            _enteredUserName = value!;
          },
        ),
        const SizedBox(height: 7),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Sic Number',
            border: border,
          ),
          focusNode: _sicFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_branchFocusNode);
          },
          // textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().length != 8) {
              return 'please enter at a valid Sic';
            }
            return null;
          },
          onSaved: (value) {
            _enteredSicNumber = value!;
          },
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Branch',
                  border: border,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                ),
                value: _enteredbranch.isNotEmpty ? _enteredbranch : null,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'CSE',
                    child: Text('CSE'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'CST',
                    child: Text('CST'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'CEN',
                    child: Text('CEN'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'ECE',
                    child: Text('ECE'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'EEE',
                    child: Text('EEE'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'EIE',
                    child: Text('EIE'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _enteredbranch = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a branch';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Year',
                  border: border,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                ),
                value:
                    _enteredStudentYear.isNotEmpty ? _enteredStudentYear : null,
                items: const [
                  DropdownMenuItem<String>(
                    value: '1st',
                    child: Text('1st'),
                  ),
                  DropdownMenuItem<String>(
                    value: '2nd',
                    child: Text('2nd'),
                  ),
                  DropdownMenuItem<String>(
                    value: '3rd',
                    child: Text('3rd'),
                  ),
                  DropdownMenuItem<String>(
                    value: '4th',
                    child: Text('4th'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _enteredStudentYear = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a year';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
              child: FilledButton(
                onPressed: () {
                  setState(() {
                    showSecondPart = true;
                  });
                },
                child: const Text('Next'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSecondPartOfForm() {
    return Column(
      children: [
        // Widgets starting from the Year field
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            border: border,
          ),
          keyboardType: TextInputType.number,
          focusNode: _phoneNumberFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_emailFocusNode);
          },
          validator: (value) {
            if (value == null || value.isEmpty || value.trim().length != 10) {
              return 'Please enter valid Phone number';
            }
            return null;
          },
          onSaved: (value) {
            _enteredPhoneNumber = value!;
          },
        ),
        const SizedBox(height: 7),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Email Address',
            border: border,
          ),
          keyboardType: TextInputType.emailAddress,
          focusNode: _emailFocusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_passwordFocusNode);
          },
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter an email address.';
            }
            // Regular expression pattern for email validation
            final emailRegex =
                RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
            if (!emailRegex.hasMatch(value)) {
              return 'Please enter a valid email address.';
            }
            // Additional check for the domain name
            if (!value.contains('@silicon.ac.in') &&
                !value.contains('@gmail.com')) {
              return 'Please enter an email address from silicon.ac.in or gmail.com domains.';
            }
            return null;
          },
          onSaved: (value) {
            _enteredEmail = value!;
          },
        ),
        const SizedBox(height: 7),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: border,
          ),
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          validator: (value) {
            if (value == null || value.length < 6) {
              return 'password is to short';
            }
            return null;
          },
          focusNode: _passwordFocusNode,
          // onFieldSubmitted: (_) {},
          onSaved: (value) {
            _enteredpassword = value!;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _isAuthenticating
                ? const CircularProgressIndicator()
                : Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        if (await _submit()) {
                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'SignUp Successfull',
                                  ),
                                  content: const Text(
                                    'Please Sign-in with the email and password',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context)
                                            .pushNamed(LoginScreen.routeName);
                                      },
                                      child: const Text(
                                        'Okay',
                                        style: TextStyle(
                                            // fontFamily: 'Barrbar',
                                            // fontSize: font15 + 5,
                                            ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        }
                        _isAuthenticating = false;
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            // fontSize: font20 * 0.4,
                            ),
                      ),
                    ),
                  ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Have an account?',
          style: TextStyle(
            height: 0.5,
            fontSize: 20,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(LoginScreen.routeName);
          },
          // style: ButtonStyle(),
          child: const Text(
            'Login instead',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
