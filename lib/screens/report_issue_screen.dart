import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart'; // Add to pubspec.yaml
import '../controllers/report_controller.dart';
import '../models/report.dart';

import '../constants/app_constants.dart';

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

    return Scaffold(
      appBar: AppBar(title: const Text("Report New Issue")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_image!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            SizedBox(height: 8),
                            Text("Add Photo/Video"),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
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
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ["Roads", "Public Safety", "Parks", "Trash", "Graffiti"]
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 20),
              Text("Severity: ${_severity.toStringAsFixed(1)}", style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _severity,
                onChanged: (v) => setState(() => _severity = v),
                min: 0,
                max: 10,
                divisions: 10,
                label: _severity.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    _severity = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final report = Report(
                      title: titleController.text,
                      category: selectedCategory,
                      status: "Submitted", // New reports are always 'Submitted' first
                      date: DateTime.now(),
                      description: descriptionController.text,
                      severity: _severity,
                      imagePath: _image?.path,
                    );
                    controller.addReport(report);
                    Get.back(); // Go back to the previous screen
                    Get.snackbar(
                      "Success",
                      "Report submitted successfully",
                       snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text("Submit Report"),
              )
            ],
          ),
        ),
      ),
    );
  }
}