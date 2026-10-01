import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/jet_model.dart';
import '../theme/app_theme.dart';
import '../widgets/concierge_modal.dart';

class JetDetailScreen extends StatefulWidget {
  final JetModel jet;
  final String route;

  const JetDetailScreen({
    super.key,
    required this.jet,
    required this.route,
  });

  @override
  State<JetDetailScreen> createState() => _JetDetailScreenState();
}

class _JetDetailScreenState extends State<JetDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  void _showBookingConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceElevated,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.goldAccent, width: 1.2),
        ),
        title: Text(
          'Flight Request Dispatched',
          style: AppTypography.serifTitle(fontSize: 26),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldAccent.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.flight_takeoff_rounded,
                color: AppColors.goldAccent,
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your VIP charter request for ${widget.jet.title} on route "${widget.route}" has been reserved.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'A Senior Flight Dispatcher is assigning your runway slot.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.goldMuted, fontSize: 13),
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Confirm',
                style: TextStyle(
                  color: AppColors.goldAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jet = widget.jet;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // Background ambient gradient glow
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            height: 320,
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppColors.goldAccent.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              children: [
                // Top Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6.0, horizontal: 4.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.textSecondary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Back',
                              style: AppTypography.sansBody(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ConciergeModal.show(context),
                      icon: const Icon(
                        Icons.support_agent_rounded,
                        color: AppColors.goldAccent,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Title & Category
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            jet.title,
                            style: AppTypography.serifTitle(fontSize: 38),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            jet.category,
                            style: AppTypography.sansLabel(
                              color: AppColors.goldMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.goldAccent.withValues(alpha: 0.35),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${jet.rating}',
                            style: const TextStyle(
                              color: AppColors.goldAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.goldAccent,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // HERO ANIMATED 3D AEROPLANE
                SizedBox(
                  height: 220,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _floatController,
                      builder: (context, child) {
                        final hoverY =
                            math.sin(_floatController.value * math.pi * 2) * 6.0;
                        final hoverRot =
                            math.cos(_floatController.value * math.pi * 2) * 0.015;

                        return Transform.translate(
                          offset: Offset(0, hoverY),
                          child: Transform.rotate(
                            angle: hoverRot,
                            child: Hero(
                              tag: 'jet_hero_${jet.id}',
                              flightShuttleBuilder: (
                                flightContext,
                                animation,
                                flightDirection,
                                fromHeroContext,
                                toHeroContext,
                              ) {
                                return Material(
                                  color: Colors.transparent,
                                  child: Image.asset(
                                    jet.imagePath,
                                    fit: BoxFit.contain,
                                  ),
                                );
                              },
                              child: Image.asset(
                                jet.imagePath,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Key Specs Cards
                Row(
                  children: [
                    _buildSpecCard(
                      title: 'Speed',
                      value: jet.speed,
                      icon: Icons.speed_rounded,
                    ),
                    const SizedBox(width: 12),
                    _buildSpecCard(
                      title: 'Max Range',
                      value: jet.range,
                      icon: Icons.public_rounded,
                    ),
                    const SizedBox(width: 12),
                    _buildSpecCard(
                      title: 'Capacity',
                      value: '${jet.capacity} seats',
                      icon: Icons.airline_seat_recline_extra_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                // Flight Charter Route Box
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Charter Route',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              widget.route,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Flight Rate',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'from ${jet.priceFrom} ${jet.priceUnit} / hr',
                              style: const TextStyle(
                                color: AppColors.goldAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // Cabin Amenities
                const Text(
                  'Cabin Amenities & Comfort',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...jet.amenities.map(
                  (amenity) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.goldAccent,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            amenity,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // "Reserve Aircraft" Action Button
                Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.goldAccent.withValues(alpha: 0.9),
                      width: 1.4,
                    ),
                    color: Colors.black.withValues(alpha: 0.4),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldAccent.withValues(alpha: 0.1),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: _showBookingConfirmation,
                      child: const Center(
                        child: Text(
                          'Reserve Aircraft',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: AppColors.goldAccent,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.goldMuted, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
