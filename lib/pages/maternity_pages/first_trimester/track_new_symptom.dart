import 'package:flutter/material.dart';

import '../../../models/profile.dart';
import '../../../models/symptoms.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../first_trimester.dart';

class TrackNewSymptom extends StatefulWidget {
  final User user;
  final Profile profile;

  const TrackNewSymptom(
      {Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrackNewSymptomState createState() =>
      _TrackNewSymptomState();
}

class _TrackNewSymptomState extends State<TrackNewSymptom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
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

      // 'symptom_category': symptom_category,
      // 'symptom_name': symptom_name,
      // 'symptom_description': symptom_description,
      // 'symptom_entry_date': symptom_entry_date,
      // 'symptom_last_edit_date': symptom_last_edit_date,

      // Create a new appointment instance with the form data
      final symptom = Symptoms(
        symptom_category: _categoryController.text,
        symptom_name: _nameController.text,
        symptom_description: _descriptionController.text,
        symptom_entry_date: 'aaa',
        symptom_last_edit_date: 'aaa',
        user_id: widget.user.user_id!,
        profile_id: widget.profile.profile_id,
      );

      try {
        // Insert the appointment into the database
        await DatabaseService().newSymptomEntry(symptom);

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
                      builder: (context) => FirstTrimester(
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
        title: const Text('New Entry'),
      ),
      body: Column(
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
                        controller: _categoryController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Symptom Category',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Enter a category';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Symptom Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Enter a symptom';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 20,
                        maxLines: null, // Set to null for multiline
                        maxLength: 1500, // Set the maximum number of characters
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Symptom Description',
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value == '') {
                            return 'Enter some text';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin:
                  const EdgeInsets.only(bottom: 16.0, left: 16.0, right: 16.0),
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 115, 176, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          25.0), // Adjust the value as needed
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
