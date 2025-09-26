import 'package:flutter/material.dart';
import 'package:nagrik/models/report.dart';

class ReportDetailsScreen extends StatelessWidget {
  final Report report;
  const ReportDetailsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Issue Details')), // <-- static title
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (report.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  report.imagePath!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),
            Text("Title: ${report.title}"), // <-- now shown below image
            Text(report.description),
            Text("Category: ${report.category}"),
            Text("Status: ${report.status}"),
            Text("Severity: ${report.severity}"),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
