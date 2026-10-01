import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'flight_search_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.15, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnim = Tween<double>(begin: 1.04, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full bleed Background Image
          Positioned.fill(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Image.asset(
                'assets/images/welcome_bg.jpg',
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),

          // Gradient Overlay to ensure crisp contrast for text and buttons
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.35),
                    Colors.black.withValues(alpha: 0.90),
                  ],
                  stops: const [0.0, 0.30, 0.65, 0.95],
                ),
              ),
            ),
          ),

          // Edge-to-Edge Screen Content
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
                      position: _slideAnim,
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

                  // Bottom Tagline & Action Button
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // "Private jet for your live, work and other goals"
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

                          // "Get started" button
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
