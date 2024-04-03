import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorasummit/src/auth/signup_screen.dart';
import 'package:sorasummit/src/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  var _enteredEmail = '';
  var _enteredpassword = '';
  var _isAuthenticating = false;
  final _passwordFocusNode = FocusNode();
  final _firebase = FirebaseAuth.instance;

  final InputBorder? border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
  );

  Future<bool> _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      //show error message
      return false;
    }

    _form.currentState!.save();
    try {
      setState(() {
        _isAuthenticating = true;
      });

      await _firebase.signInWithEmailAndPassword(
        email: _enteredEmail,
        password: _enteredpassword,
      );
      setState(() {
        _isAuthenticating = false;
      });
      return true;
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed';
      if (error.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (error.code == 'wrong-password') {
        errorMessage = 'Wrong password provided for that user.';
      } else if (error.code == 'network-request-failed') {
        errorMessage = 'Network error, please try again later.';
      }
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(errorMessage),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
      return false;
    } catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('An unexpected error occurred.'),
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
      return false;
    }
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final font20 = screenHeight * 0.07;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                // SizedBox(
                //   height: screenHeight * 0.01,
                // ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight * 0.025,
                      top: screenHeight * 0.025,
                    ),
                    child: Text(
                      'Sign In',
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
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            border: border,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              // this validation should pass the silicon id test
                              return 'Please enter a valid email address.';
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
                              labelText: 'Password', border: border),
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          focusNode: _passwordFocusNode,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            _enteredpassword = value!;
                          },
                        ),
                        const SizedBox(height: 10),
                        _isAuthenticating
                            ? const CircularProgressIndicator()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () async {
                                        if (await _submit()) {
                                          Navigator.of(context)
                                              .pushReplacementNamed(
                                            HomeScreen.routeName,
                                          ); // gives error when loggin(route problem)
                                        }
                                      },
                                      child: Text(
                                        'Sign in',
                                        style:
                                            TextStyle(fontSize: font20 * 0.3),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(height: 30),

                        //Dont have account text
                        if (!_isAuthenticating)
                          const Text(
                            'Don\'t have an account?',
                            style: TextStyle(
                              height: 0.5,
                              fontSize: 20,
                            ),
                          ),
                        if (!_isAuthenticating)
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                SignUpScreen.routeName,
                              );
                            },
                            child: const Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 20,
                              ),
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
}
