import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pulse_marker.dart';
import 'jet_selection_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeHeaderAnim;
  late Animation<Offset> _slideHeaderAnim;
  late Animation<double> _fadeFormAnim;
  late Animation<Offset> _slideFormAnim;
  late Animation<double> _fadeButtonAnim;
  late Animation<Offset> _slideButtonAnim;
  late Animation<double> _globeScaleAnim;

  String _selectedFrom = 'New York (JFK)';
  String _selectedTo = 'London (LHR)';

  final List<String> _availableAirports = const [
    'New York (JFK)',
    'London (LHR)',
    'Dubai (DXB)',
    'Singapore (SIN)',
    'Tokyo (HND)',
    'Geneva (GVA)',
    'Nice Côte d\'Azur (NCE)',
    'Los Angeles (VNY)',
    'Miami (OPF)',
    'Paris Le Bourget (LFPB)',
  ];

  int _passengers = 4;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    // Globe scale animation
    _globeScaleAnim = Tween<double>(begin: 1.06, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
      ),
    );

    // Header animation
    _fadeHeaderAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
    );
    _slideHeaderAnim = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.1, 0.65, curve: Curves.easeOutCubic),
      ),
    );

    // Form inputs animation
    _fadeFormAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.25, 0.75, curve: Curves.easeOut),
    );
    _slideFormAnim = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.25, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    // Bottom "Choose airplane" button sliding up from deep below
    _fadeButtonAnim = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
    );
    _slideButtonAnim = Tween<Offset>(
      begin: const Offset(0, 1.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showAirportPicker({required bool isDeparture}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isDeparture ? 'Departure Airport' : 'Destination Airport',
                style: AppTypography.serifTitle(fontSize: 26),
              ),
              const SizedBox(height: 16),
              ..._availableAirports.map(
                (airport) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: AppColors.goldAccent,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    airport,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: (isDeparture ? _selectedFrom : _selectedTo) == airport
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.goldAccent)
                      : null,
                  onTap: () {
                    setState(() {
                      if (isDeparture) {
                        _selectedFrom = airport;
                      } else {
                        _selectedTo = airport;
                      }
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showMenuDrawer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: 0.3),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Private Aviation Services',
                style: AppTypography.serifTitle(fontSize: 28),
              ),
              const SizedBox(height: 20),
              _buildMenuItem(Icons.airplanemode_active, 'Fleet Showcase'),
              _buildMenuItem(Icons.flash_on, 'Empty Legs & Jet Deals'),
              _buildMenuItem(Icons.shield_outlined, 'Safety & Flight Standards'),
              _buildMenuItem(Icons.support_agent, '24/7 Concierge Support'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppColors.goldAccent, size: 20),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          const Icon(
            Icons.chevron_right,
            color: AppColors.textMuted,
            size: 20,
          ),
        ],
      ),
    );
  }

  void _navigateToJetSelection() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            JetSelectionScreen(
          fromCity: _selectedFrom,
          toCity: _selectedTo,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnim = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          return FadeTransition(
            opacity: curvedAnim,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curvedAnim),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
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
          // Background Giant 3D Globe
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.58,
            child: ScaleTransition(
              scale: _globeScaleAnim,
              child: const AnimatedGlobeFlightMap(),
            ),
          ),

          // Top Header Bar: Golden Hamburger Menu Icon
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, top: 12),
                child: InkWell(
                  onTap: _showMenuDrawer,
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 2.2,
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 24,
                          height: 2.2,
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 24,
                          height: 2.2,
                          decoration: BoxDecoration(
                            color: AppColors.goldAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet / Card Section: "Your flight"
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              decoration: BoxDecoration(
                color: AppColors.bgPrimary.withValues(alpha: 0.96),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.85),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: "Your flight" and Filter icon
                    FadeTransition(
                      opacity: _fadeHeaderAnim,
                      child: SlideTransition(
                        position: _slideHeaderAnim,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your flight',
                              style: AppTypography.serifTitle(
                                fontSize: 40,
                                color: AppColors.goldAccent,
                              ),
                            ),
                            InkWell(
                              onTap: () => _showFilterDialog(context),
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: AppColors.goldAccent,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // "From" & "To" inputs with staggered entrance
                    FadeTransition(
                      opacity: _fadeFormAnim,
                      child: SlideTransition(
                        position: _slideFormAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "From"
                            const Text(
                              'From',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInputBox(
                              text: _selectedFrom,
                              onTap: () => _showAirportPicker(isDeparture: true),
                            ),
                            const SizedBox(height: 16),

                            // "To"
                            const Text(
                              'To',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildInputBox(
                              text: _selectedTo,
                              onTap: () => _showAirportPicker(isDeparture: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // "Choose airplane" Action Button sliding up from bottom
                    FadeTransition(
                      opacity: _fadeButtonAnim,
                      child: SlideTransition(
                        position: _slideButtonAnim,
                        child: InkWell(
                          onTap: _navigateToJetSelection,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.goldAccent.withValues(alpha: 0.85),
                                width: 1.4,
                              ),
                              color: Colors.black.withValues(alpha: 0.35),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.goldAccent.withValues(alpha: 0.08),
                                  blurRadius: 16,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Choose airplane',
                                style: AppTypography.serifTitle(
                                  fontSize: 22,
                                  color: AppColors.goldAccent,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox({
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1B1D21),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF2B2E34),
            width: 1.0,
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.goldAccent.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Flight Preferences',
                style: AppTypography.serifTitle(fontSize: 26),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Passengers',
                      style: TextStyle(color: AppColors.textPrimary)),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _passengers > 1
                            ? () {
                                setState(() => _passengers--);
                                Navigator.pop(context);
                                _showFilterDialog(context);
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline,
                            color: AppColors.goldAccent),
                      ),
                      Text('$_passengers',
                          style: const TextStyle(
                              color: AppColors.textGold,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: _passengers < 16
                            ? () {
                                setState(() => _passengers++);
                                Navigator.pop(context);
                                _showFilterDialog(context);
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline,
                            color: AppColors.goldAccent),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.goldAccent,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply Preferences',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
