import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/medication.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import 'list_medication.dart';

class MedicationForm extends StatefulWidget {
  final User user;
  final Profile profile;

  const MedicationForm({Key? key, required this.user, required this.profile})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationFormState createState() => _MedicationFormState();
}

class _MedicationFormState extends State<MedicationForm> {
  final List<GlobalKey<FormState>> _formKeys = List.generate(
    5,
    (index) => GlobalKey<FormState>(),
  );
  final List<TextEditingController> _controllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  int _currentStep = 0;

  // ----------------------------------------------------------------------
  // Submit form

  // Submit form
  void _submitForm() async {
    if (_formKeys[_currentStep].currentState!.validate()) {
      // Save the values of the current step's form fields
      _formKeys[_currentStep].currentState!.save();

      if (_currentStep < 4) {
        // Move to the next step if not the last step
        setState(() {
          _currentStep++;
        });
      } else {
        // Last step, submit the form
        try {
          // Create a new medication instance with the form data
          final medication = Medication(
            medication_name: _controllers[0].text,
            medication_type: _controllers[1].text,
            medication_day: _controllers[2].text,
            medication_time: _controllers[3].text,
            medication_quantity: int.parse(_controllers[4].text),
            user_id: widget.user.user_id!,
            profile_id: widget.profile.profile_id!,
          );

          // Insert the medication into the database
          await DatabaseService().insertMedication(medication);

          // Show success dialog
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
                    for (int i = 0; i < _controllers.length; i++) {
                      _controllers[i].clear();
                    }

                    // Navigate to the medication list
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListMedication(
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
          // Show error dialog
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
        }
      }
    }
  }

  // ----------------------------------------------------------------------
  // Required validator

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stepper(
              currentStep: _currentStep,
              onStepContinue: () {
                if (_formKeys[_currentStep].currentState!.validate()) {
                  setState(() {
                    _currentStep < 4 ? _currentStep++ : _currentStep = 0;
                  });
                }
              },
              onStepCancel: () {
                setState(() {
                  _currentStep > 0 ? _currentStep-- : _currentStep = 0;
                });
              },
              steps: [
                _buildStep(
                  title: 'Medication Name',
                  stepIndex: 0,
                ),
                _buildStep(
                  title: 'Medication Type',
                  stepIndex: 1,
                ),
                _buildStep(
                  title: 'Medication Day',
                  stepIndex: 2,
                ),
                _buildStep(
                  title: 'Medication Time',
                  stepIndex: 3,
                ),
                _buildStep(
                  title: 'Medication Quantity',
                  stepIndex: 4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 45.0,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitForm,
              child:
                  const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Step _buildStep({required String title, required int stepIndex}) {
    return Step(
      title: Text(title),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKeys[stepIndex],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title == 'Medication Quantity')
                  TextFormField(
                    controller: _controllers[stepIndex],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: title,
                    ),
                    validator: _requiredValidator,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                  ),
                if (title != 'Medication Quantity')
                  TextFormField(
                    controller: _controllers[stepIndex],
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: title,
                    ),
                    validator: _requiredValidator,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
