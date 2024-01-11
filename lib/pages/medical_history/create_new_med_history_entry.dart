import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/medical_history/list_medical_history.dart';

import '../../models/medical_history.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';

class CreateNewMedHistoryEntry extends StatefulWidget {
  final User user;
  final Profile profile;

  const CreateNewMedHistoryEntry(
      {Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CreateNewMedHistoryEntryState createState() =>
      _CreateNewMedHistoryEntryState();
}

class _CreateNewMedHistoryEntryState extends State<CreateNewMedHistoryEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  // bool _isDateSelected = false;

  // // ----------------------------------------------------------------------
  // // Date Picker

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime(DateTime.now().day + 1),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 1),
  //   );

  //   if (picked != null) {
  //     setState(() {
  //       _dateController.text =
  //           picked.toIso8601String().split('T')[0];
  //       _isDateSelected = true; // Set the flag to true when date is selected
  //     });
  //   }
  // }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Required validator

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // ----------------------------------------------------------------------

  // Submit form
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // if (_isDateSelected) {
      final date = _dateController.text;

      // Create a new appointment instance with the form data
      final medicalHistory = MedicalHistory(
        title: _titleController.text,
        body: _bodyController.text,
        datetime_posted: 'aaa',
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
      );

      try {
        // Insert the appointment into the database
        await DatabaseService().newMedHistoryEntry(medicalHistory);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Form submitted successfully!'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  // Clear the text fields after submitting the form
                  _formKey.currentState!.reset();
                  _dateController.clear();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListMedicalHistory(
                        user: widget.user,
                        profile: widget.profile,
                        autoImplyLeading: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      } catch (error) {
        // Handle any errors that occur during the database operation
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('An error occurred: $error'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
        // }
      }
    }
  }

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextFormField(
              //   controller: _dateController,
              //   decoration: const InputDecoration(
              //     border: OutlineInputBorder(),
              //     labelText: 'Date',
              //   ),
              //   readOnly: true,
              //   onTap: () {
              //     _selectDate(context);
              //   },
              //   validator: _requiredValidator,
              // ),

              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Entry Title',
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bodyController,
                maxLines: null, // Set to null for multiline
                maxLength: 1500, // Set the maximum number of characters
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Entry Body',
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: 45.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
