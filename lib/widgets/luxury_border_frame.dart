import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LuxuryFramedScreen extends StatelessWidget {
  final Widget child;

  const LuxuryFramedScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: child,
    );
  }
}
