import 'package:flutter/material.dart';

class GlobePin {
  final String code;
  final String city;

  const GlobePin({
    required this.code,
    required this.city,
  });
}

class AnimatedGlobeFlightMap extends StatefulWidget {
  const AnimatedGlobeFlightMap({
    super.key,
  });

  @override
  State<AnimatedGlobeFlightMap> createState() => _AnimatedGlobeFlightMapState();
}

class _AnimatedGlobeFlightMapState extends State<AnimatedGlobeFlightMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Stack(
          fit: StackFit.expand,
          children: [
            // Giant realistic 3D relief globe entering from top-right
            Image.asset(
              'assets/images/globe.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.4, -0.6),
            ),

            // Soft luxury ambient gradient blend at the bottom of the globe
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 120,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Color(0xFF090A0B),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
