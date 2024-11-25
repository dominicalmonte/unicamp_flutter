import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart'; // Import AuthProvider
import 'provider/search_provider.dart'; // Import SearchProvider
import 'pages/login_screen.dart';
import 'pages/homepage.dart';
import 'firebase_options.dart'; // Ensure you have the Firebase config file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Firebase configuration
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: ChangeNotifierProvider(
        create: (_) => SearchProvider(), // Add SearchProvider here
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const Homepage(),
      },
    );
  }
}
