import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik_alya_iman_mobile_app/services/misc_methods/medication_list.dart';

import '../../../models/medication.dart';
import '../../../models/profile.dart';
import '../../../models/user.dart';
import 'medication_type.dart';

class MedicationNamePage extends StatefulWidget {
  final Medication medication;
  final User user;
  final Profile profile;

  const MedicationNamePage({
    Key? key,
    required this.medication,
    required this.user,
    required this.profile,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MedicationNamePageState createState() => _MedicationNamePageState();
}

class _MedicationNamePageState extends State<MedicationNamePage> {
  final TextEditingController _medicationNameController =
      TextEditingController();

  final List<String> _medications = globalMedicationList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Medication'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        'Medication Name',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'What is the name of your medication?',
                          style: TextStyle(
                              fontSize: 16.0,
                              color: Color(0xFFB6CBFF),
                              height: 1.5),
                        )),
                    const SizedBox(height: 32.0),
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return _medications
                            .where((String option) => option
                                .toLowerCase()
                                .startsWith(
                                    textEditingValue.text.toLowerCase()))
                            .take(5);
                      },
                      onSelected: (String selection) {
                        _medicationNameController.text = selection;
                      },
                      fieldViewBuilder: (
                        BuildContext context,
                        _medicationNameController,
                        FocusNode focusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        return TextField(
                          controller: _medicationNameController,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFF4D5FC0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            labelText: 'Medication Name',
                            labelStyle:
                                const TextStyle(color: Color(0xFFB6CBFF)),
                            counterText:
                                '', // This hides the default counter text
                          ),
                          maxLength: 50,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                50), // Set the maximum number of characters
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: itemCount,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      return InkWell(
                                        onTap: () {
                                          onSelected(option);
                                        },
                                        child: Container(
                                          // Customize the color of each suggestion item here
                                          padding: const EdgeInsets.all(16.0),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF303E8F),
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

                    // TextField(
                    //   controller: _medicationNameController,
                    //   decoration: InputDecoration(
                    //     filled: true,
                    //     fillColor: const Color(0xFF4D5FC0),
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(25.0),
                    //     ),
                    //     contentPadding: const EdgeInsets.symmetric(
                    //         vertical: 16.0, horizontal: 20.0),
                    //     labelText: 'Medication Name',
                    //     labelStyle: const TextStyle(color: Color(0xFFB6CBFF)),
                    //   ),
                    //   maxLength: 50,
                    //   inputFormatters: [
                    //     LengthLimitingTextInputFormatter(
                    //         50), // Set the maximum number of characters
                    //   ],
                    //   buildCounter: (
                    //     BuildContext context, {
                    //     required int currentLength,
                    //     required int? maxLength,
                    //     required bool isFocused,
                    //   }) {
                    //     return Text(
                    //       '$currentLength / $maxLength',
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: isFocused
                    //             ? const Color(0xFFB6CBFF)
                    //             : const Color(0x00FFFFFF),
                    //       ),
                    //     );
                    //   },
                    // ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                  bottom: 16.0,
                  left: 16.0,
                  right: 16.0), // Set your desired margin
              child: SizedBox(
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFC1D3FF), // Set the fill color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          50.0), // Adjust the value as needed
                    ),
                    side: const BorderSide(
                      color: Color(0xFF6086f6), // Set the outline color
                      width: 2.5, // Set the outline width
                    ),
                  ),
                  onPressed: () {
                    final medicationName = _medicationNameController.text;
                    if (medicationName.isNotEmpty) {
                      final medication = Medication(
                        medication_name: medicationName,
                        medication_type: '',
                        frequency_type: '',
                        frequency_interval: 0,
                        daily_frequency: 0,
                        medication_day: '',
                        next_dose_day: '',
                        dose_times: '',
                        medication_quantity: 0,
                        user_id: widget.user.user_id!,
                        profile_id: widget.profile.profile_id!,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicationTypePage(
                            medication: medication,
                            user: widget.user,
                            profile: widget.profile,
                          ),
                        ),
                      );
                    } else {
                      _showHoveringMessage(
                          context, 'Please enter medication name');
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     content: Text('Please enter a medication name.',
                      //         style: TextStyle(fontFamily: 'ProductSans')),
                      //   ),
                      // );
                    }
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1F3299)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showHoveringMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height *
          0.37, // Adjust position as needed
      left: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Remove the overlay entry after 2 seconds
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
