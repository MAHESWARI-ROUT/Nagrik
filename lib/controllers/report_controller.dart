import 'package:get/get.dart';
import '../models/report.dart';

class ReportController extends GetxController {
  var reports = <Report>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Add dummy data when the controller is initialized
    addDummyReports();
  }

  int get submittedCount => reports.length;
  int get inProgressCount => reports.where((r) => r.status == 'In Progress').length;
  int get resolvedCount => reports.where((r) => r.status == 'Resolved').length;

  void addReport(Report report) {
    reports.insert(0, report);
  }

  void addDummyReports() {
    reports.addAll([
      Report(
        title: "Pothole on Main St.",
        category: "Roads",
        status: "Resolved",
        date: DateTime.now().subtract(const Duration(days: 2)),
        description: "Large pothole causing traffic issues near the intersection.",
        severity: 8.0,
        imagePath: 'https://res.cloudinary.com/dzfx0uwka/image/upload/v1758831489/pothole_sxzhf7.jpg', // Example asset path
      ),
      Report(
        title: "Park Bench Damaged",
        category: "Parks",
        status: "In Progress",
        date: DateTime.now().subtract(const Duration(days: 5)),
        description: "A bench near the playground is broken and unsafe.",
        severity: 6.0,
        imagePath: "https://res.cloudinary.com/dzfx0uwka/image/upload/v1758831490/bench_epxzey.jpg", // Example asset path
      ),
      Report(
        title: "Street Light Out",
        category: "Streetlight",
        status: "Submitted",
        date: DateTime.now().subtract(const Duration(days: 1)),
        description: "The streetlight at the corner of Oak & Pine is not working.",
        severity: 7.0,
        imagePath: 'https://res.cloudinary.com/dzfx0uwka/image/upload/v1758831489/light_e0p2jk.jpg',
      ),
    ]);
  }
}