import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/jet_model.dart';
import '../theme/app_theme.dart';
import '../widgets/concierge_modal.dart';
import '../widgets/jet_detail_modal.dart';
import '../widgets/luxury_border_frame.dart';

class JetSelectionScreen extends StatefulWidget {
  final String fromCity;
  final String toCity;

  const JetSelectionScreen({
    super.key,
    this.fromCity = 'New York (JFK)',
    this.toCity = 'London (LHR)',
  });

  @override
  State<JetSelectionScreen> createState() => _JetSelectionScreenState();
}

class _JetSelectionScreenState extends State<JetSelectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  late AnimationController _floatingController;
  bool _showAll = false;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..forward();

    // Subtle gentle floating/hover animation for real planes
    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jetsToDisplay =
        _showAll ? JetModel.sampleJets : JetModel.sampleJets.take(3).toList();

    return LuxuryFramedScreen(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          children: [
              // Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 4.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
              ),
              const SizedBox(height: 12),

              // Title: "Choose your jet" + Filter icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Choose your jet',
                      style: AppTypography.serifTitle(
                        fontSize: 34,
                        color: AppColors.goldAccent,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => ConciergeModal.show(context),
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.goldAccent,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Jet List Cards with animated aeroplane glide-in
              ...List.generate(jetsToDisplay.length, (index) {
                final jet = jetsToDisplay[index];
                final startInterval = (index * 0.2).clamp(0.0, 0.8);
                final endInterval = (startInterval + 0.45).clamp(0.0, 1.0);

                final cardFade = CurvedAnimation(
                  parent: _staggerController,
                  curve: Interval(startInterval, endInterval,
                      curve: Curves.easeOut),
                );

                final cardSlide = Tween<Offset>(
                  begin: const Offset(0.25, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _staggerController,
                  curve: Interval(startInterval, endInterval,
                      curve: Curves.easeOutCubic),
                ));

                final planeGlide = Tween<Offset>(
                  begin: Offset(
                    index == 0
                        ? -0.6
                        : index == 1
                            ? -0.7
                            : 0.0,
                    index == 0
                        ? -0.5
                        : index == 1
                            ? 0.4
                            : -0.6,
                  ),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _staggerController,
                  curve: Interval(startInterval + 0.1, 1.0,
                      curve: Curves.easeOutQuart),
                ));

                return FadeTransition(
                  opacity: cardFade,
                  child: SlideTransition(
                    position: cardSlide,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: AnimatedBuilder(
                        animation: _floatingController,
                        builder: (context, child) {
                          // Gentle realistic hovering pitch & elevation
                          final hoverOffset = math.sin(_floatingController.value *
                                      math.pi *
                                      2 +
                                  (index * 1.5)) *
                              4.0;
                          final hoverAngle = math.cos(_floatingController.value *
                                      math.pi *
                                      2 +
                                  (index * 1.5)) *
                              0.015;

                          return _buildJetCard(
                            jet: jet,
                            index: index,
                            planeGlide: planeGlide,
                            hoverOffset: hoverOffset,
                            hoverAngle: hoverAngle,
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),

              // "Show all" Button
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _showAll = !_showAll;
                    });
                  },
                  child: Text(
                    _showAll ? 'Show less' : 'Show all',
                    style: const TextStyle(
                      color: AppColors.goldAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Help text: "Do not know which one you need, call us and we will help you"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Do not know which one you need, call us and we will help you',
                  textAlign: TextAlign.center,
                  style: AppTypography.sansBody(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // "Call us" Button
              Container(
                width: double.infinity,
                height: 52,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.goldAccent.withOpacity(0.9),
                    width: 1.4,
                  ),
                  color: Colors.black.withOpacity(0.4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.goldAccent.withOpacity(0.1),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => ConciergeModal.show(context),
                    child: const Center(
                      child: Text(
                        'Call us',
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
            ],
          ),
        ),
      );
  }

  Widget _buildJetCard({
    required JetModel jet,
    required int index,
    required Animation<Offset> planeGlide,
    required double hoverOffset,
    required double hoverAngle,
  }) {
    return GestureDetector(
      onTap: () {
        JetDetailModal.show(
          context,
          jet,
          '${widget.fromCity} → ${widget.toCity}',
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Card Container
          Container(
            height: 118,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.fromLTRB(136, 12, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.border,
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Jet Title & Subtitle
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jet.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      jet.description,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),

                // Rating & Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Rating e.g. "4,8 ★"
                    Row(
                      children: [
                        Text(
                          jet.rating.toString().replaceAll('.', ','),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.goldAccent,
                          size: 16,
                        ),
                      ],
                    ),

                    // Price e.g. "from 900 $"
                    Text(
                      'from ${jet.priceFrom} ${jet.priceUnit}',
                      style: const TextStyle(
                        color: AppColors.goldAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Real Aeroplane image breaking out of the card with dynamic glide & hover
          Positioned(
            left: index == 0
                ? -30
                : index == 1
                    ? -24
                    : -20,
            top: (index == 0
                    ? -22
                    : index == 1
                        ? 2
                        : -14) +
                hoverOffset,
            child: SlideTransition(
              position: planeGlide,
              child: Transform.rotate(
                angle: hoverAngle,
                child: SizedBox(
                  width: index == 0
                      ? 180
                      : index == 1
                          ? 185
                          : 175,
                  height: 135,
                  child: Image.asset(
                    jet.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
