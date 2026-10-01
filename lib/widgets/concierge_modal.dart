import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ConciergeModal extends StatelessWidget {
  const ConciergeModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const ConciergeModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: AppColors.goldBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 48,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.textMuted.withOpacity(0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Private Aviation Concierge',
            style: AppTypography.serifTitle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Our 24/7 dedicated flight dispatchers will arrange bespoke quotes, custom catering, and immediate ramp access.',
            style: AppTypography.sansBody(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),

          // Options
          _buildActionTile(
            icon: Icons.phone_in_talk_rounded,
            title: 'Direct Voice Line',
            subtitle: '+1 (800) 792-JETS • Priority Routing',
            onTap: () {
              Navigator.pop(context);
              _showToast(context, 'Connecting to Senior Aviation Advisor...');
            },
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.chat_bubble_outline_rounded,
            title: 'WhatsApp VIP Desk',
            subtitle: 'Instant messaging with flight coordinator',
            onTap: () {
              Navigator.pop(context);
              _showToast(context, 'Opening VIP Concierge Chat...');
            },
          ),
          const SizedBox(height: 12),
          _buildActionTile(
            icon: Icons.mail_outline_rounded,
            title: 'Custom Flight Proposal',
            subtitle: 'Receive itinerary breakdown in 15 mins',
            onTap: () {
              Navigator.pop(context);
              _showToast(context, 'Proposal request dispatched.');
            },
          ),
          const SizedBox(height: 28),

          // Close button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textMuted,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Dismiss', style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.goldAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.goldAccent.withOpacity(0.3),
                  ),
                ),
                child: Icon(icon, color: AppColors.goldAccent, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.goldMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.surfaceElevated,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.goldAccent, width: 0.8),
        ),
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: AppColors.goldAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
