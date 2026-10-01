import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class LuxuryBackgroundPainter extends CustomPainter {
  final double animationProgress;

  LuxuryBackgroundPainter({this.animationProgress = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final glowPaint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Curved background luxury flight flow lines
    final path1 = Path();
    path1.moveTo(-size.width * 0.2, size.height * 0.35);
    path1.cubicTo(
      size.width * 0.4,
      size.height * 0.25,
      size.width * 0.8,
      size.height * 0.55,
      size.width * 1.3,
      size.height * 0.45,
    );

    final path2 = Path();
    path2.moveTo(-size.width * 0.1, size.height * 0.65);
    path2.cubicTo(
      size.width * 0.3,
      size.height * 0.5,
      size.width * 0.7,
      size.height * 0.8,
      size.width * 1.2,
      size.height * 0.7,
    );

    final path3 = Path();
    path3.moveTo(size.width * 0.5, -size.height * 0.1);
    path3.cubicTo(
      size.width * 0.9,
      size.height * 0.2,
      size.width * 0.2,
      size.height * 0.8,
      size.width * 0.9,
      size.height * 1.1,
    );

    canvas.drawPath(path1, glowPaint);
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, glowPaint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);

    // Decorative corner slashes on bottom right "//"
    _drawCornerSlashes(canvas, size);
  }

  void _drawCornerSlashes(Canvas canvas, Size size) {
    final slashPaint = Paint()
      ..color = AppColors.goldAccent.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.5;

    final startX = size.width - 24;
    final startY = size.height - 28;

    // First slash
    canvas.drawLine(
      Offset(startX, startY),
      Offset(startX - 10, startY + 18),
      slashPaint,
    );

    // Second slash
    canvas.drawLine(
      Offset(startX + 10, startY),
      Offset(startX, startY + 18),
      slashPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LuxuryBackgroundPainter oldDelegate) {
    return oldDelegate.animationProgress != animationProgress;
  }
}

class LuxuryFramedScreen extends StatelessWidget {
  final Widget child;
  final bool showCornerSlashes;
  final bool showOuterBorder;

  const LuxuryFramedScreen({
    super.key,
    required this.child,
    this.showCornerSlashes = true,
    this.showOuterBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          // Background subtle luxury curves
          Positioned.fill(
            child: CustomPaint(
              painter: LuxuryBackgroundPainter(),
            ),
          ),
          // Main Screen Content
          SafeArea(
            child: showOuterBorder
                ? Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: AppColors.goldAccent.withOpacity(0.35),
                        width: 1.5,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: child,
                  )
                : child,
          ),
        ],
      ),
    );
  }
}
