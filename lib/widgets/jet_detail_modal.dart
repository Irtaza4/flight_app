import 'package:flutter/material.dart';
import '../models/jet_model.dart';
import '../theme/app_theme.dart';

class JetDetailModal extends StatelessWidget {
  final JetModel jet;
  final String route;

  const JetDetailModal({
    super.key,
    required this.jet,
    required this.route,
  });

  static void show(BuildContext context, JetModel jet, String route) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => JetDetailModal(jet: jet, route: route),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.goldBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.9),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Title & Category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        jet.title,
                        style: AppTypography.serifTitle(fontSize: 32),
                      ),
                      Text(
                        jet.category,
                        style: AppTypography.sansLabel(
                          color: AppColors.goldMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.goldBorder),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${jet.rating}',
                          style: const TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.star,
                            color: AppColors.goldAccent, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Aeroplane 3D Preview
              SizedBox(
                height: 180,
                child: Center(
                  child: Image.asset(
                    jet.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Specs Grid
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
              const SizedBox(height: 24),

              // Route & Charter estimate
              Container(
                padding: const EdgeInsets.all(16),
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
                        Text(
                          route,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
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
                        Text(
                          'from ${jet.priceFrom} ${jet.priceUnit} / hr',
                          style: const TextStyle(
                            color: AppColors.goldAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

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
                      Text(
                        amenity,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Book button
              Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.goldAccent, width: 1.5),
                  gradient: LinearGradient(
                    colors: [
                      AppColors.goldAccent.withOpacity(0.2),
                      AppColors.goldDark.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      Navigator.pop(context);
                      _showBookingConfirmation(context, jet);
                    },
                    child: const Center(
                      child: Text(
                        'Reserve Aircraft',
                        style: TextStyle(
                          color: AppColors.goldAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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

  void _showBookingConfirmation(BuildContext context, JetModel jet) {
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
          style: AppTypography.serifTitle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldAccent.withOpacity(0.15),
              ),
              child: const Icon(
                Icons.flight_takeoff_rounded,
                color: AppColors.goldAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your charter slot for ${jet.title} on route "$route" has been tentatively reserved.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            const Text(
              'A VIP Flight Director is finalizing your slot clearance with ATC.',
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
                'Done',
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
}
