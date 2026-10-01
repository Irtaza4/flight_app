import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/luxury_border_frame.dart';
import '../widgets/pulse_marker.dart';
import 'jet_selection_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  GlobePin _selectedFrom = const GlobePin(
    code: 'JFK',
    city: 'New York (JFK)',
    xRatio: 0.32,
    yRatio: 0.30,
  );

  GlobePin _selectedTo = const GlobePin(
    code: 'LHR',
    city: 'London (LHR)',
    xRatio: 0.52,
    yRatio: 0.22,
  );

  final List<GlobePin> _availableAirports = const [
    GlobePin(code: 'JFK', city: 'New York (JFK)', xRatio: 0.32, yRatio: 0.30),
    GlobePin(code: 'LHR', city: 'London (LHR)', xRatio: 0.52, yRatio: 0.22),
    GlobePin(code: 'DXB', city: 'Dubai (DXB)', xRatio: 0.88, yRatio: 0.28),
    GlobePin(code: 'SIN', city: 'Singapore (SIN)', xRatio: 0.58, yRatio: 0.39),
    GlobePin(code: 'HND', city: 'Tokyo (HND)', xRatio: 0.75, yRatio: 0.44),
    GlobePin(code: 'GVA', city: 'Geneva (GVA)', xRatio: 0.49, yRatio: 0.24),
    GlobePin(code: 'NCE', city: 'Nice Côte d\'Azur (NCE)', xRatio: 0.48, yRatio: 0.26),
    GlobePin(code: 'VNY', city: 'Los Angeles (VNY)', xRatio: 0.22, yRatio: 0.33),
  ];

  int _passengers = 4;

  void _onPinTapped(GlobePin pin) {
    setState(() {
      if (_selectedFrom.code == pin.code) {
        // Already selected
      } else {
        _selectedTo = pin;
      }
    });
  }

  void _showAirportPicker({required bool isDeparture}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppColors.goldBorder, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                isDeparture ? 'Select Departure Airport' : 'Select Destination Airport',
                style: AppTypography.serifTitle(fontSize: 24),
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
                    child: const Icon(Icons.flight_takeoff_rounded,
                        color: AppColors.goldAccent, size: 18),
                  ),
                  title: Text(
                    airport.city,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    'ICAO / IATA code: ${airport.code}',
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  trailing: (isDeparture
                              ? _selectedFrom.code
                              : _selectedTo.code) ==
                          airport.code
                      ? const Icon(Icons.check, color: AppColors.goldAccent)
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
            ],
          ),
        );
      },
    );
  }

  void _navigateToJetSelection() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            JetSelectionScreen(
          fromCity: _selectedFrom.city,
          toCity: _selectedTo.city,
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
        transitionDuration: const Duration(milliseconds: 650),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LuxuryFramedScreen(
      showCornerSlashes: true,
      child: Column(
        children: [
          // Top Half: 3D Globe with Flight Map
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedGlobeFlightMap(
                    selectedFrom: _selectedFrom,
                    selectedTo: _selectedTo,
                    onPinTapped: _onPinTapped,
                  ),
                ),
                // Subtle back arrow if navigation stack exists
                if (Navigator.canPop(context))
                  Positioned(
                    top: 16,
                    left: 16,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.goldAccent,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Bottom Half: "Your flight" Card
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.bgPrimary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: "Your flight" + Filter Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Your flight',
                        style: AppTypography.serifTitle(
                          fontSize: 34,
                          color: AppColors.goldAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _showFilterDialog(context);
                        },
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.goldAccent,
                          size: 26,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // "From" Input Field
                  const Text(
                    'From',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildLocationSelector(
                    text: _selectedFrom.city,
                    icon: Icons.flight_takeoff_rounded,
                    onTap: () => _showAirportPicker(isDeparture: true),
                  ),
                  const SizedBox(height: 12),

                  // "To" Input Field
                  const Text(
                    'To',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildLocationSelector(
                    text: _selectedTo.city,
                    icon: Icons.flight_land_rounded,
                    onTap: () => _showAirportPicker(isDeparture: false),
                  ),

                  const Spacer(),

                  // "Choose airplane" Action Button
                  Container(
                    width: double.infinity,
                    height: 52,
                    margin: const EdgeInsets.only(bottom: 6),
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
                        onTap: _navigateToJetSelection,
                        child: const Center(
                          child: Text(
                            'Choose airplane',
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
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelector({
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.goldMuted, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.unfold_more_rounded,
              color: AppColors.textMuted,
              size: 18,
            ),
          ],
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
            border: Border.all(color: AppColors.goldBorder),
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
