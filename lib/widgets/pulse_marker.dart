import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GlobePin {
  final String code;
  final String city;
  final double xRatio; // Relative 0.0 - 1.0 on globe container
  final double yRatio;

  const GlobePin({
    required this.code,
    required this.city,
    required this.xRatio,
    required this.yRatio,
  });
}

class AnimatedGlobeFlightMap extends StatefulWidget {
  final GlobePin selectedFrom;
  final GlobePin selectedTo;
  final Function(GlobePin pin)? onPinTapped;

  const AnimatedGlobeFlightMap({
    super.key,
    required this.selectedFrom,
    required this.selectedTo,
    this.onPinTapped,
  });

  @override
  State<AnimatedGlobeFlightMap> createState() => _AnimatedGlobeFlightMapState();
}

class _AnimatedGlobeFlightMapState extends State<AnimatedGlobeFlightMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  static const List<GlobePin> samplePins = [
    GlobePin(code: 'JFK', city: 'New York', xRatio: 0.32, yRatio: 0.30),
    GlobePin(code: 'LHR', city: 'London', xRatio: 0.52, yRatio: 0.22),
    GlobePin(code: 'DXB', city: 'Dubai', xRatio: 0.88, yRatio: 0.28),
    GlobePin(code: 'SIN', city: 'Singapore', xRatio: 0.58, yRatio: 0.39),
    GlobePin(code: 'HND', city: 'Tokyo', xRatio: 0.75, yRatio: 0.44),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Realistic 3D Globe Image
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/globe.jpg',
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            // Flight Arc Painter overlay
            Positioned.fill(
              child: CustomPaint(
                painter: FlightArcPainter(
                  progress: _animController.value,
                  from: widget.selectedFrom,
                  to: widget.selectedTo,
                ),
              ),
            ),

            // Pulsing Golden Waypoint Markers
            ...samplePins.map((pin) {
              final isSelected = pin.code == widget.selectedFrom.code ||
                  pin.code == widget.selectedTo.code;

              return Positioned(
                left: (MediaQuery.of(context).size.width * pin.xRatio) - 16,
                top: (280 * pin.yRatio) - 16,
                child: GestureDetector(
                  onTap: () => widget.onPinTapped?.call(pin),
                  child: PulseMarker(
                    animationProgress: _animController.value,
                    isSelected: isSelected,
                    label: pin.code,
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

class PulseMarker extends StatelessWidget {
  final double animationProgress;
  final bool isSelected;
  final String label;

  const PulseMarker({
    super.key,
    required this.animationProgress,
    required this.isSelected,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final waveScale = 1.0 + (animationProgress * 0.8);
    final waveAlpha = (1.0 - animationProgress).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer expanding ripple
            Transform.scale(
              scale: waveScale,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.goldAccent.withOpacity(0.35 * waveAlpha),
                ),
              ),
            ),
            // Glowing core
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.goldLight,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.goldAccent.withOpacity(0.8),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
            // Center white dot
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ],
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: AppColors.goldAccent.withOpacity(0.5),
                width: 0.8,
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppColors.goldAccent,
              ),
            ),
          ),
      ],
    );
  }
}

class FlightArcPainter extends CustomPainter {
  final double progress;
  final GlobePin from;
  final GlobePin to;

  FlightArcPainter({
    required this.progress,
    required this.from,
    required this.to,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(size.width * from.xRatio, size.height * from.yRatio);
    final p2 = Offset(size.width * to.xRatio, size.height * to.yRatio);

    // Control point for curved flight trajectory
    final midX = (p1.dx + p2.dx) / 2;
    final midY = (p1.dy + p2.dy) / 2 - 45; // arch upwards
    final controlPoint = Offset(midX, midY);

    final path = Path();
    path.moveTo(p1.dx, p1.dy);
    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, p2.dx, p2.dy);

    // Base arc line
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final glowLinePaint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    canvas.drawPath(path, glowLinePaint);
    canvas.drawPath(path, linePaint);

    // Animated traveling pulse light along the bezier curve
    final t = progress;
    final movingX = (1 - t) * (1 - t) * p1.dx +
        2 * (1 - t) * t * controlPoint.dx +
        t * t * p2.dx;
    final movingY = (1 - t) * (1 - t) * p1.dy +
        2 * (1 - t) * t * controlPoint.dy +
        t * t * p2.dy;

    final headPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final headGlow = Paint()
      ..color = AppColors.goldAccent
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(movingX, movingY), 4, headGlow);
    canvas.drawCircle(Offset(movingX, movingY), 2.5, headPaint);
  }

  @override
  bool shouldRepaint(covariant FlightArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.from != from ||
        oldDelegate.to != to;
  }
}
