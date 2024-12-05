import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart'; 
import 'provider/search_provider.dart'; 
import 'pages/login_screen.dart';
import 'pages/homepage.dart';
import 'pages/splash_screen.dart'; 
import 'firebase_options.dart';

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
      initialRoute: '/', // Set initial route to splash screen
      routes: {
        '/': (context) => SplashScreen(), // Splash screen as the initial route
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomePage(),
      },
    );
  }
}