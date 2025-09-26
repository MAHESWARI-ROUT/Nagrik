import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // Add to pubspec.yaml
import '../controllers/report_controller.dart';
import '../models/report.dart';

import '../constants/app_constants.dart';
// Add import for audio packages if necessary (not included here)

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String selectedCategory = "Roads";
  double _severity = 5.0;
  File? _image;

  Position? _currentPosition;
  String? _address;
  bool _isRecording = false;
  File? _voiceNoteFile; // Placeholder for actual recorded audio file

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      Placemark place = placemarks.first;
      setState(() {
        _currentPosition = pos;
        _address =
            "${place.name != null && place.name!.isNotEmpty ? place.name! + ', ' : ''}"
                "${place.street != null && place.street!.isNotEmpty ? place.street! + ', ' : ''}"
                "${place.subLocality != null && place.subLocality!.isNotEmpty ? place.subLocality! + ', ' : ''}"
                "${place.locality != null && place.locality!.isNotEmpty ? place.locality! + ', ' : ''}"
                "${place.postalCode != null && place.postalCode!.isNotEmpty ? place.postalCode! + ', ' : ''}"
                "${place.country ?? ''}".replaceAll(', ,', ',').trim();
      });
    } else {
      Get.snackbar(
        "Permission Denied",
        "Location permission is required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _currentLocationSection() {
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
          const Text("Current Location", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: Icon(Icons.my_location, color: Colors.teal),
            label: const Text("Detect My Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[50],
              foregroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onPressed: _getCurrentLocation,
          ),
          if (_currentPosition != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  "Latitude: ",
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                ),
                Text(
                  "${_currentPosition!.latitude}",
                  style: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "Longitude: ",
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                ),
                Text(
                  "${_currentPosition!.longitude}",
                  style: TextStyle(color: Colors.teal[800], fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_address != null && _address!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Landmark: ",
                    style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    child: Text(
                      _address!,
                      style: TextStyle(color: Colors.blueGrey[800], fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
          ]
        ],
      ),
    );
  }

  Widget _voiceNoteInput() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[100]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(_isRecording ? Icons.stop_circle : Icons.mic, color: Colors.teal, size: 28),
            onPressed: () async {
              setState(() => _isRecording = !_isRecording);
              // Add your audio record/stop logic here with proper packages!
            },
            tooltip: _isRecording ? 'Stop Recording' : 'Record Voice Note',
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _isRecording
                  ? "Recording..."
                  : _voiceNoteFile != null
                  ? "Voice note attached"
                  : "Tap mic to add voice note",
              style: TextStyle(
                color: _isRecording ? Colors.redAccent : Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_voiceNoteFile != null)
            IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.teal),
              onPressed: () {
                // Add playback logic for audio
              },
              tooltip: "Play Voice Note",
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ReportController controller = Get.find<ReportController>();
    final categories = ["Roads", "Public Safety", "Parks", "Trash", "Graffiti"];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Report New Issue"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.teal, width: 1.2),
                  ),
                  child: Center(
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 120),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo_camera_outlined, size: 36, color: Colors.grey[700]),
                        const SizedBox(width: 18),
                        Icon(Icons.cloud_upload_outlined, size: 36, color: Colors.teal),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Add Photo/Video",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Title input
              TextFormField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  hintText: "Issue title",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter a title" : null,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    hintText: "Describe the issue…",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _voiceNoteInput(),
              const SizedBox(height: 8),
              Container(
                height: 28,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      "Map View",
                      style: TextStyle(fontSize: 13, color: Colors.blueGrey[400]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _currentLocationSection(),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Category:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[700])),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                  items: categories
                      .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedCategory = val!),
                  isExpanded: true,
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Description:", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.grey[700])),
              ),
              const SizedBox(height: 5),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Low", style: TextStyle(color: Colors.grey)),
                  Text("High", style: TextStyle(color: Colors.grey)),
                ],
              ),
              Slider(
                value: _severity,
                onChanged: (v) => setState(() => _severity = v),
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: Colors.teal,
                inactiveColor: Colors.teal.withOpacity(0.2),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final report = Report(
                        title: titleController.text,
                        category: selectedCategory,
                        status: "Submitted",
                        date: DateTime.now(),
                        description: descriptionController.text,
                        severity: _severity,
                        imagePath: _image?.path,
                        // voiceNotePath: _voiceNoteFile?.path,  // Add to Report model if needed
                        // latitude: _currentPosition?.latitude, // Add to Report model if needed
                        // longitude: _currentPosition?.longitude, // Add to Report model if needed
                        // landmark: _address, // Add to Report model if needed
                      );
                      controller.addReport(report);
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Report submitted successfully",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: const Text(
                    "Submit Report",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
