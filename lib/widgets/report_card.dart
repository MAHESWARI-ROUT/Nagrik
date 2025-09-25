import 'dart:io';
import 'package:flutter/material.dart';
import '../models/report.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias, // Important for the image corners
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (report.imagePath != null && report.imagePath!.isNotEmpty)
            Image.file(
              File(report.imagePath!),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // This is a fallback for dummy asset paths that won't resolve.
                // In a real app, you'd handle this more gracefully.
                return Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                );
              },
            ),
          ListTile(
            title: Text(report.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("${report.category} • ${report.status}"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.arrow_upward, color: Colors.green, size: 16),
                Text("${report.severity.toInt()} Upvotes", style: const TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}