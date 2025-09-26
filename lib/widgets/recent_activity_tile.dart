import 'dart:io';
import 'package:flutter/material.dart';
import '../models/report.dart';

class RecentActivityTile extends StatelessWidget {
  final Report report;
  const RecentActivityTile({super.key, required this.report});

  bool _isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  bool _isAssetImage(String path) {
    return path.startsWith('assets/');
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 44,
          width: 44,
          child: _buildImage(report.imagePath ?? ''),
        ),
      ),
      title: Text(
        report.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            report.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _statusColor(report.status).withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              report.status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _statusColor(report.status),
              ),
            ),
          ),
        ],
      ),
      trailing: Text(
        "${report.date.day}/${report.date.month}",
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.isEmpty) {
      return Container(color: Colors.grey[200]);
    }
    if (_isNetworkImage(path)) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            Container(color: Colors.grey[300]),
      );
    } else if (_isAssetImage(path)) {
      return Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            Container(color: Colors.grey[300]),
      );
    } else {
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stack) =>
            Container(color: Colors.grey[300]),
      );
    }
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "resolved":
        return Colors.teal;
      case "in progress":
        return Colors.orange;
      case "submitted":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
