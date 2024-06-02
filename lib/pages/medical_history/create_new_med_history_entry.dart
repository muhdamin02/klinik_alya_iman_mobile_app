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
        datetime_posted: DateTime.now().toString(),
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
      );

      try {
        // Insert the appointment into the database
        await DatabaseService().newMedHistoryEntry(medicalHistory);

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              title: const Text('Success'),
              content: const Text('Diary entry has been added!'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
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
          ),
          barrierDismissible: false,
        );
      } catch (error) {
        // Handle any errors that occur during the database operation
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: const Color(0xFF303E8F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              title: const Text('Error'),
              content: Text('An error occurred: $error'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK',
                      style: TextStyle(color: Color(0xFFEDF2FF))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
          barrierDismissible: false,
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
        title: const Text('New Entry'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
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
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF4D5FC0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: 'Entry Title',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB6CBFF)),
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '') {
                                return 'Enter an entry title';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Color(0xFFEDF2FF)),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: _bodyController,
                            minLines: 20,
                            maxLines: null, // Set to null for multiline
                            maxLength:
                                1500, // Set the maximum number of characters
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF4D5FC0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              labelText: 'Entry Body',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB6CBFF)),
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value == '') {
                                return 'Enter some text';
                              }
                              return null;
                            },
                            style: const TextStyle(color: Color(0xFFEDF2FF)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 60.0,
                width: MediaQuery.of(context).size.width - 34, // Adjust padding
                child: FloatingActionButton.extended(
                  onPressed: _submitForm,
                  icon: const Icon(Icons.edit_document),
                  label: const Text('Create Entry'),
                  elevation: 0,
                  backgroundColor:
                      const Color(0xFFC1D3FF), // Set background color here
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25), // Adjust the border radius
                    side: const BorderSide(
                        width: 2.5,
                        color: Color(0xFF6086f6)), // Set the outline color here
                  ),
                  foregroundColor:
                      const Color(0xFF1F3299), // Set text and icon color here
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
