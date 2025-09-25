class Report {
  final String title;
  final String category;
  final String status;
  final DateTime date;
  final String description;
  final double severity;
  final String? imagePath; // Path to the image file

  Report({
    required this.title,
    required this.category,
    required this.status,
    required this.date,
    required this.description,
    required this.severity,
    this.imagePath,
  });
}