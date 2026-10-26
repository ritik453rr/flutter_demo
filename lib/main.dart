import 'package:demo/core/constants/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:toastification/toastification.dart';
import 'core/constants/app_keys.dart';
import 'core/storage/app_storage.dart';
import 'features/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await AppStorage.init();

  // Load environment variables from .env
  await dotenv.load(fileName: ".env");

  // Initialize Supabase with loaded environment variables
  await Supabase.initialize(
    url: AppKeys.supabaseUrl,
    publishableKey: AppKeys.supabaseAnonKey,
  );

  runApp(const MyApp());
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashPage(),
      ),
    );
  }
}
