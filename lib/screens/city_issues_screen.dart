import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nagrik/screens/issue_details_screen.dart';
import '../controllers/report_controller.dart';
import '../widgets/report_card.dart';
import '../models/report.dart';

class CityIssuesScreen extends StatefulWidget {
  const CityIssuesScreen({super.key});

  @override
  State<CityIssuesScreen> createState() => _CityIssuesScreenState();
}

class _CityIssuesScreenState extends State<CityIssuesScreen> {
  String selectedCity = "Bhubaneswar";
  final List<String> cities = ['Bhubaneswar', 'Cuttack', 'Delhi', 'Mumbai', 'Chennai', 'Kolkata'];

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text("Nagrik"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // City select banner as a button
          Padding(
            padding: const EdgeInsets.all(12),
            child: GestureDetector(
              onTap: () => _showCityPicker(context),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.location_on, color: Colors.teal, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "City: $selectedCity",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.arrow_drop_down_sharp, color: Colors.grey[400], size: 20),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ),
          ),

          // Filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(label: const Text('All (Active)', style: TextStyle(color: Colors.teal)), selected: true, onSelected: (_) {}),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('In-Progress'), selected: false, onSelected: (_) {}),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('Graffiti'), selected: false, onSelected: (_) {}),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('Street Light'), selected: false, onSelected: (_) {}),
                  const SizedBox(width: 8),
                  FilterChip(label: const Text('Map View'), selected: false, onSelected: (_) {}),
                ],
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.reports.isEmpty) {
                return const Center(child: Text("No issues reported yet."));
              }
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: controller.reports.length,
                itemBuilder: (context, index) {
                  final report = controller.reports[index];
                  return ReportCard(
                    report: report,
                    onTap: () {
                      // Example: Navigate to details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReportDetailsScreen(report: report),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showCityPicker(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String query = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredCities = cities
                .where((city) => city.toLowerCase().contains(query.toLowerCase()))
                .toList();
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search city...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() => query = value),
                    ),
                  ),
                  ...filteredCities.map((city) => ListTile(
                        leading: const Icon(Icons.location_city),
                        title: Text(city),
                        onTap: () => Navigator.pop(context, city),
                      )),
                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );

    if (result != null && result != selectedCity) {
      setState(() {
        selectedCity = result;
        // Optionally, fetch city-specific reports
      });
    }
  }
}

// Simple details screen example
