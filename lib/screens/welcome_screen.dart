import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'flight_search_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _flightHoverController;

  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideTextAnim;
  late Animation<double> _scaleSkyAnim;
  late Animation<Offset> _planeEntranceAnim;
  late Animation<double> _planeRotateAnim;
  late Animation<double> _planeScaleAnim;

  @override
  void initState() {
    super.initState();

    // Main entrance orchestration controller (1.8s)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Continuous cruising hover animation (gentle aerodynamic float)
    _flightHoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3600),
    )..repeat(reverse: true);

    // Sky background zoom
    _scaleSkyAnim = Tween<double>(begin: 1.08, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Text fade & slide
    _fadeAnim = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
    );
    _slideTextAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.1, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    // Aeroplane dynamic entrance: gliding in from right side
    _planeEntranceAnim = Tween<Offset>(
      begin: const Offset(1.1, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.95, curve: Curves.easeOutQuart),
      ),
    );

    // Aeroplane pitch rotation settling into cruising alignment
    _planeRotateAnim = Tween<double>(begin: 0.10, end: 0.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.12, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    // Aeroplane subtle scale settling
    _planeScaleAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.15, 0.95, curve: Curves.easeOutCubic),
      ),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _flightHoverController.dispose();
    super.dispose();
  }

  void _navigateToFlightSearch() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FlightSearchScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnim = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curvedAnim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(curvedAnim),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 550),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Starry Sky & Sunset Horizon Background (Separate Layer)
          Positioned.fill(
            child: ScaleTransition(
              scale: _scaleSkyAnim,
              child: Image.asset(
                'assets/images/welcome_sky_bg.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // 2. Animated Real 3D Aeroplane Layer (Completely uncropped, glides in & hovers)
          Positioned(
            top: screenSize.height * 0.18,
            left: 0,
            right: 0,
            height: screenSize.height * 0.48,
            child: AnimatedBuilder(
              animation: _flightHoverController,
              builder: (context, child) {
                // Gentle aerodynamic cruising oscillation
                final hoverOffset = math.sin(_flightHoverController.value * math.pi * 2) * 6.0;
                final hoverAngle = math.cos(_flightHoverController.value * math.pi * 2) * 0.015;

                return SlideTransition(
                  position: _planeEntranceAnim,
                  child: Transform.translate(
                    offset: Offset(0, hoverOffset),
                    child: Transform.rotate(
                      angle: _planeRotateAnim.value + hoverAngle,
                      child: ScaleTransition(
                        scale: _planeScaleAnim,
                        child: Image.asset(
                          'assets/images/welcome_plane_hero.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 3. Contrast & Ambient Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.88),
                  ],
                  stops: const [0.0, 0.28, 0.65, 0.95],
                ),
              ),
            ),
          ),

          // 4. UI Content: Header & Bottom Actions
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Header: "Welcome\naboard —————"
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideTextAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome',
                            style: AppTypography.serifTitle(
                              fontSize: 54,
                              height: 1.0,
                              color: AppColors.goldAccent,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'aboard',
                                style: AppTypography.serifTitle(
                                  fontSize: 54,
                                  height: 1.0,
                                  color: AppColors.goldAccent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: AppColors.goldAccent.withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Bottom Tagline & "Get started" button
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideTextAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tagline
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 260),
                            child: Text(
                              'Private jet for your live, work and other goals',
                              style: AppTypography.sansBody(
                                fontSize: 18,
                                color: AppColors.goldAccent.withValues(alpha: 0.95),
                                height: 1.35,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Action Button
                          InkWell(
                            onTap: _navigateToFlightSearch,
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 13,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.goldAccent.withValues(alpha: 0.8),
                                  width: 1.4,
                                ),
                                color: Colors.black.withValues(alpha: 0.35),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.goldAccent.withValues(alpha: 0.1),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Get started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.goldAccent,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
