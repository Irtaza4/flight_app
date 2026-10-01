class JetModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final double rating;
  final int reviewsCount;
  final int priceFrom;
  final String priceUnit;
  final String imagePath;
  final String range;
  final String speed;
  final int capacity;
  final List<String> amenities;

  const JetModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.rating,
    required this.reviewsCount,
    required this.priceFrom,
    this.priceUnit = '\$',
    required this.imagePath,
    required this.range,
    required this.speed,
    required this.capacity,
    required this.amenities,
  });

  static const List<JetModel> sampleJets = [
    JetModel(
      id: 'jet_1',
      title: 'Airplan',
      category: 'Ultra Long Range',
      description: 'The most comfortable and faster plane for your goals...',
      rating: 4.8,
      reviewsCount: 142,
      priceFrom: 900,
      priceUnit: '\$',
      imagePath: 'assets/images/jet_airplan.png',
      range: '7,500 nm',
      speed: 'Mach 0.925',
      capacity: 14,
      amenities: [
        'Master Suite with Bed',
        'Ka-band High Speed Wi-Fi',
        'Full Convection Galley',
        'Ensuite Shower & Lavatory',
        'Noise Cancellation Cabin',
      ],
    ),
    JetModel(
      id: 'jet_2',
      title: 'Private Jet',
      category: 'Heavy Executive',
      description: 'Perfect and the most faster plane',
      rating: 5.0,
      reviewsCount: 98,
      priceFrom: 700,
      priceUnit: '\$',
      imagePath: 'assets/images/jet_private.png',
      range: '7,700 nm',
      speed: 'Mach 0.90',
      capacity: 12,
      amenities: [
        'Club Seating for 12',
        'Club Suite Conference Table',
        'Gourmet Dining Service',
        'Satellite Phone & Wi-Fi',
        'Direct Baggage Access',
      ],
    ),
    JetModel(
      id: 'jet_3',
      title: 'Famaly plane',
      category: 'VIP Super-Midsize',
      description: 'The most comfortable and faster plane for your goals...',
      rating: 4.7,
      reviewsCount: 86,
      priceFrom: 1000,
      priceUnit: '\$',
      imagePath: 'assets/images/jet_family.png',
      range: '3,500 nm',
      speed: '880 km/h',
      capacity: 8,
      amenities: [
        'Spacious Family Lounge',
        'Child-friendly Entertainment',
        'Pet-friendly Cabin',
        'Full Reclining Berthable Seats',
        'Lavatory with Vanity',
      ],
    ),
    JetModel(
      id: 'jet_4',
      title: 'Global Express',
      category: 'Long Range Transcontinental',
      description: 'Effortless non-stop global journeys with maximum luxury.',
      rating: 4.9,
      reviewsCount: 110,
      priceFrom: 1200,
      priceUnit: '\$',
      imagePath: 'assets/images/jet_airplan.png',
      range: '6,000 nm',
      speed: 'Mach 0.89',
      capacity: 16,
      amenities: [
        'Private Stateroom',
        'Fine Dining Service',
        'High-Speed Connectivity',
        'Full Bar & Lounge',
      ],
    ),
  ];
}
