import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:sorasummit/providers/user_data_provider.dart';

import 'package:sorasummit/src/auth/login_screen.dart';
import 'package:sorasummit/src/admin/screens/admin_home_screen.dart';
import 'package:sorasummit/src/home/screens/order_history_screen.dart';

class ProfileDialogBox extends ConsumerWidget {
  const ProfileDialogBox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider) ?? ['student'];
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              insetPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
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
                  if (userRole.contains('administrator'))
                    ListTile(
                      onTap: () => {
                        Navigator.of(context)
                            .popAndPushNamed(AdminHomeScreen.routeName),
                      },
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('Adminstrator'),
                    ),
                  ListTile(
                    onTap: () => {
                      Navigator.of(context)
                          .pushNamed(OrderHistoryScreen.routeName),
                    },
                    leading: const Icon(Icons.history_rounded),
                    title: const Text('Order history'),
                  ),
                  ListTile(
                    onTap: () => {},
                    leading: const Icon(Icons.person),
                    title: const Text('Profile'),
                  ),
                  ListTile(
                    onTap: () => {},
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                  ),
                  const Divider(
                    indent: 10,
                    endIndent: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app_rounded,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    onTap: () {
                      try {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Alert',
                              ),
                              content: const Text(
                                'Are you sure you want to Sign-out',
                              ),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexMono',
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                    await FirebaseAuth.instance.signOut();
                                    ref.invalidate(userDataProvider);
                                    await Navigator.of(context)
                                        .popAndPushNamed(LoginScreen.routeName);
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'No',
                                    style: TextStyle(
                                      fontFamily: 'IBMPlexMono',
                                      fontSize: 20,
                                    ),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } on FirebaseAuthException catch (error) {
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text(
                              error.message ??
                                  'You ran into an unexpected error',
                            ),
                          ),
                        );
                      }
                    },
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
    );
  }
}
