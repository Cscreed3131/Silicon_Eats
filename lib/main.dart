import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sorasummit/firebase_options.dart';
import 'package:sorasummit/providers/user_data_provider.dart';
import 'package:sorasummit/src/admin/screens/add_food_item_screen.dart';
import 'package:sorasummit/src/admin/screens/admin_home_screen.dart';
import 'package:sorasummit/src/admin/screens/create_announcement_screen.dart';
import 'package:sorasummit/src/auth/login_screen.dart';
import 'package:sorasummit/src/auth/signup_screen.dart';
import 'package:sorasummit/src/home/screens/announcement_screen.dart';
import 'package:sorasummit/src/home/screens/cart_screen.dart';
import 'package:sorasummit/src/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRole = ref.watch(userRoleProvider); // get user role
    return MaterialApp(
      title: 'Sora Summit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          // seedColor: Colors.orange,
          // primary: const Color(0xFFF66118),
          // secondary: const Color(0xFFFF9200),
          // background: Colors.white,
          // outline: const Color(0xFFFF4500),
          // outlineVariant: const Color(0xFFFF7518),
          seedColor: Colors.green,
          // background: const Color(0xFFF7FEEF),
          background: const Color(0xFFF9FEFF),
          primary: const Color(0xFF276221),
          secondary: const Color(0xFF3B8132),
          tertiary: const Color(0xFFF1F9EC),
          primaryContainer: const Color(0xFFACD8A7),
          onPrimary: const Color(0xFF1DB233),
          outline: const Color(0xFF3B8132),
          outlineVariant: const Color(0xFF46923C),
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            elevation: MaterialStatePropertyAll(1),
          ),
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              // Get the user data
              return _getHomeScreen(
                  userRole!); // render different home screens based on user role// Pass the user data to HomeScreen
            } else {
              return const LoginScreen();
            }
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routeName: (ctx) => const LoginScreen(),
        SignUpScreen.routeName: (ctx) => const SignUpScreen(),
        AdminHomeScreen.routeName: (ctx) => const AdminHomeScreen(),
        HomeScreen.routeName: (ctx) => const HomeScreen(),
        AddFoodItemScreen.routeName: (ctx) => const AddFoodItemScreen(),
        CreateAnnouncement.routeName: (ctx) => const CreateAnnouncement(),
        AnnouncementScreen.routeName: (ctx) => const AnnouncementScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
      },
    );
  }

  Widget _getHomeScreen(List roles) {
    if (roles.contains('Administrator')) {
      return const AdminHomeScreen();
    } else if (roles.contains('Student')) {
      return const HomeScreen();
    } else {
      return const HomeScreen();
    }
  }
}
