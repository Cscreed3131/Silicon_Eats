import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sorasummit/firebase_options.dart';
import 'package:sorasummit/providers/user_data_provider.dart';
import 'package:sorasummit/screens/admin/admin_home_screen.dart';
import 'package:sorasummit/screens/auth/login_screen.dart';
import 'package:sorasummit/screens/auth/signup_screen.dart';
import 'package:sorasummit/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
    ref.watch(userDataProvider);
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
          primary: const Color(0xFF276221),
          secondary: const Color(0xFF3B8132),
          background: const Color(0xFFF7FEEF),
          primaryContainer: const Color(0xFFACD8a7),
          onPrimary: const Color(0xFF1DB233),
          outline: const Color(0xFF3B8132),
          outlineVariant: const Color(0xFF46923C),
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
              return const HomeScreen();
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
      },
    );
  }
}
