import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.bgPrimary,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const PrivateJetApp());
}

class PrivateJetApp extends StatelessWidget {
  const PrivateJetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Private Jet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.bgPrimary,
        primaryColor: AppColors.goldAccent,
        canvasColor: AppColors.surface,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.goldAccent,
          secondary: AppColors.goldLight,
          surface: AppColors.surface,
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
