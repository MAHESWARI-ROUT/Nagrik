import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_stats_card.dart';
import '../widgets/recent_activity_tile.dart';
import '../constants/app_constants.dart';

class MyReportsScreen extends StatelessWidget {
  const MyReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Reports"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: ReportStatsCard(
                      icon: Icons.upload_file,
                      count: controller.submittedCount,
                      label: "Submitted",
                      color: AppConstants.lightTeal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReportStatsCard(
                      icon: Icons.hourglass_top,
                      count: controller.inProgressCount,
                      label: "In-Progress",
                      color: AppConstants.orange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReportStatsCard(
                      icon: Icons.check_circle,
                      count: controller.resolvedCount,
                      label: "Resolved",
                      color: AppConstants.lightGreen,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Avg Resolution Time (Days)",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(fontSize: 12);
                          String text;
                          switch (value.toInt()) {
                            case 0: text = 'Jan'; break;
                            case 1: text = 'Roads'; break;
                            case 2: text = 'Pothole'; break;
                            case 3: text = 'Trash'; break;
                            default: text = ''; break;
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(text, style: style),
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => const FlLine(
                      color: Colors.black12,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    makeGroupData(0, 12, AppConstants.lightTeal),
                    makeGroupData(1, 8, AppConstants.orange),
                    makeGroupData(2, 5, AppConstants.lightTeal),
                    makeGroupData(3, 4, AppConstants.orange),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Recent Activity",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Obx(
              () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.reports.length,
                itemBuilder: (context, index) {
                  final report = controller.reports[index];
                  return RecentActivityTile(report: report);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}

String? selectedAddress; // Keep this in your state

Widget _locationPickerSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Set Location", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.map, color: Colors.teal),
                label: Text("Select from Map"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[50],
                  foregroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  // TODO: Open your map picker here and get coordinates
                  // For example:
                  // final coords = await Navigator.push(...);
                  // setState(() { selectedAddress = "LatLng..."; });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.my_location, color: Colors.teal),
                label: Text("Current Location"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal[50],
                  foregroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () async {
                  // TODO: Get current device location using geolocator package
                  // setState(() { selectedAddress = "LatLng..."; });
                },
              ),
            ),
          ],
        ),
        if (selectedAddress != null)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "Selected: $selectedAddress",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
      ],
    ),
  );
}
