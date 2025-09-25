import 'package:flutter/material.dart';
import '../models/report.dart';

class RecentActivityTile extends StatelessWidget {
  final Report report;
  const RecentActivityTile({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications, color: Colors.blue),
      title: Text(report.title),
      subtitle: Text(report.description),
      trailing: Text(
        "${report.date.day}/${report.date.month}",
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}
