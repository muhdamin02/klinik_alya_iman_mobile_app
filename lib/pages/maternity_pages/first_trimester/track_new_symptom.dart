import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/profile.dart';
import '../../../models/symptoms.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/global_symptom_category.dart';
import '../../../services/misc_methods/global_symptom_names.dart';
import '../first_trimester.dart';
import 'symptoms_list.dart';

class TrackNewSymptom extends StatefulWidget {
  final User user;
  final Profile profile;

  const TrackNewSymptom({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TrackNewSymptomState createState() => _TrackNewSymptomState();
}

class _TrackNewSymptomState extends State<TrackNewSymptom> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _names = globalSymptomNames();
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
        symptom_entry_date: DateTime.now().toString(),
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
                      builder: (context) => SymptomsList(
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
                          Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return _names
                                  .where((String option) => option
                                      .toLowerCase()
                                      .startsWith(
                                          textEditingValue.text.toLowerCase()))
                                  .take(5);
                            },
                            onSelected: (String selection) {
                              _nameController.text = selection;
                            },
                            fieldViewBuilder: (
                              BuildContext context,
                              TextEditingController fieldController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted,
                            ) {
                              return TextFormField(
                                controller: fieldController,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFF4D5FC0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 20.0),
                                  labelText: 'Symptom Name',
                                  labelStyle:
                                      const TextStyle(color: Color(0xFFB6CBFF)),
                                  counterText:
                                      '', // This hides the default counter text
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value == '') {
                                    return 'Enter a symptom';
                                  }
                                  return null;
                                },
                                maxLength: 35,
                                onChanged: (text) {
                                  _nameController.text = text;
                                },
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(
                                      35), // Set the maximum number of characters
                                ],
                                buildCounter: (
                                  BuildContext context, {
                                  required int currentLength,
                                  required int? maxLength,
                                  required bool isFocused,
                                }) {
                                  return Text(
                                    '$currentLength / $maxLength',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isFocused
                                          ? const Color(0xFFB6CBFF)
                                          : const Color(0x00FFFFFF),
                                    ),
                                  );
                                },
                              );
                            },
                            optionsViewBuilder: (
                              BuildContext context,
                              AutocompleteOnSelected<String> onSelected,
                              Iterable<String> options,
                            ) {
                              int itemCount = options.length;
                              double boxHeight = itemCount * 52.0;
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 66),
                                  child: Material(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: SizedBox(
                                      height: boxHeight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF303E8F),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: itemCount,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final String option =
                                                options.elementAt(index);
                                            return InkWell(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: Container(
                                                // Customize the color of each suggestion item here
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xFF303E8F),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  option,
                                                  style: const TextStyle(
                                                      color: Color(
                                                          0xFFB6CBFF)), // Customize the text color here
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _descriptionController,
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
                              labelText: 'Symptom Description',
                              labelStyle:
                                  const TextStyle(color: Color(0xFFB6CBFF)),
                              counterText: '',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
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
                  icon: const Icon(Icons.track_changes),
                  label: const Text('Track New Symptom'),
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
