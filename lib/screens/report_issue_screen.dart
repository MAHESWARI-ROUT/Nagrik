import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
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
                decoration: const InputDecoration(labelText: "Issue Title"),
                validator: (val) => val == null || val.isEmpty ? "Enter a title" : null,
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
                min: 0,
                max: 10,
                divisions: 10,
                activeColor: AppConstants.orange,
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
                  backgroundColor: AppConstants.lightGreen,
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