import 'package:flutter/material.dart';
import 'package:bus_booking/screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bus_booking/screens/auth/signup_screen.dart';
import 'package:bus_booking/main/main_page.dart';
import 'package:flutter_paymob/flutter_paymob.dart';
import 'package:bus_booking/core/config/paymob_config.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterPaymob.instance.initialize(
    apiKey: PaymobConfig.apiKey,
    integrationID: PaymobConfig.integrationId,
    walletIntegrationId: PaymobConfig.walletIntegrationId,
    iFrameID: PaymobConfig.iframeId,
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF2E8B57, <int, Color>{
          50: Color(0xFFE3F2E8),
          100: Color(0xFFC8E6C9),
          200: Color(0xFFA5D6A7),
          300: Color(0xFF81C784),
          400: Color(0xFF66BB6A),
          500: Color(0xFF2E8B57),
          600: Color(0xFF2E8B57),
          700: Color(0xFF2E8B57),
          800: Color(0xFF2E8B57),
          900: Color(0xFF101418),
        }),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF101418),
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE9ECEF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2E8B57), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E8B57),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: Color(0xFF2E8B57),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Color(0xFF2E8B57),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 16,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const MainPage(),
      },
    );
  }
}
