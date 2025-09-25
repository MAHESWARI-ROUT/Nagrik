import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_card.dart';

class CityIssuesScreen extends StatelessWidget {
  const CityIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();

    return Scaffold(
      appBar: AppBar(title: const Text("City Issues")),
      body: Obx(() {
        if (controller.reports.isEmpty) {
          return const Center(
            child: Text("No issues reported yet."),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.reports.length,
          itemBuilder: (context, index) {
            final report = controller.reports[index];
            return ReportCard(report: report);
          },
        );
      }),
    );
  }
}
