import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/profile.dart';
import '../../../models/user.dart';
import '../../../services/database_service.dart';
import '../../../services/misc_methods/get_first_two_words.dart';

class ViewPatientAdmin extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ViewPatientAdmin({
    Key? key,
    required this.user,
    required this.profile,
    required this.autoImplyLeading,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewPatientAdminState createState() => _ViewPatientAdminState();
}

class _ViewPatientAdminState extends State<ViewPatientAdmin> {
  List<Profile> _profileInfo = [];
  String _maternityValue = 'No';
  bool viewMore = false;
  bool viewLess = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileInfo();
    _maternityValue = widget.profile.maternity;
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchProfileInfo() async {
    List<Profile> profileInfo =
        await DatabaseService().profileInfo(widget.profile.profile_id);
    setState(() {
      _profileInfo = profileInfo;
    });
  }
  // ----------------------------------------------------------------------

  void _handleMaternitySelection(maternityValue) async {
    print('Maternity to be set: ${widget.profile.profile_id}');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Maternity Status'),
          content: Builder(
            builder: (BuildContext context) {
              return Text(
                  'Are you sure you want to set maternity status for ${widget.profile.name} to $maternityValue?');
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await DatabaseService()
                    .setMaternity(widget.profile.profile_id!, maternityValue);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                _fetchProfileInfo();
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    String cleanedDate = widget.profile.dob.replaceAll(" at", "");
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(cleanedDate);
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(getFirstTwoWords(widget.profile.name)),
          elevation: 0,
          iconTheme: const IconThemeData(
            color: Color(0xFFEDF2FF),
          ),
          automaticallyImplyLeading: widget.autoImplyLeading,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                              color: Color(0xFFEDF2FF), letterSpacing: 2),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Color(0xFFB6CBFF),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF303E8F),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "FULL NAME",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.profile.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity, // Adjust padding as needed
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Adjust the radius
                    ),
                    elevation: 0, // Set the elevation for the card
                    color: const Color(0xFF303E8F),
                    child: Padding(
                      padding: const EdgeInsets.all(28.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle onTap action here
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "IC/PASSPORT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.profile.identification,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Color(0xFFEDF2FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        "BIRTH DATE",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFB6CBFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  formattedDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: SizedBox(
                        width: double.infinity, // Adjust padding as needed
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30.0), // Adjust the radius
                          ),
                          elevation: 0, // Set the elevation for the card
                          color: const Color(0xFF303E8F),
                          child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // Handle onTap action here
                                  },
                                  child: const Row(
                                    children: [
                                      Text(
                                        "GENDER",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFB6CBFF),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.profile.gender}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFEDF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: viewLess,
                  child: const SizedBox(height: 8.0),
                ),
                AnimatedOpacity(
                  opacity: viewLess ? 1.0 : 0.0,
                  duration: const Duration(
                      milliseconds: 300), // Adjust the duration as needed
                  curve: Curves.easeInOut, // Adjust the curve as needed
                  child: Visibility(
                    visible: viewLess,
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              viewLess = !viewLess;
                              viewMore = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: const Color(0xFF222E75),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(
                                      0xFFB6CBFF), // Set the color of the icon
                                  size:
                                      20, // Adjust the size of the icon as needed
                                ),
                                Spacer(),
                                Text(
                                  "view more",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(
                                      0xFFB6CBFF), // Set the color of the icon
                                  size:
                                      20, // Adjust the size of the icon as needed
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: viewMore,
                  child: const SizedBox(height: 4),
                ),
                Row(
                  children: [
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: viewMore ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 500), // Adjust the duration as needed
                        curve: Curves.easeInOut, // Adjust the curve as needed
                        child: Visibility(
                          visible: viewMore,
                          child: SizedBox(
                            width: double.infinity, // Adjust padding as needed
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Adjust the radius
                              ),
                              elevation: 0, // Set the elevation for the card
                              color: const Color(0xFF303E8F),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap action here
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "ETHNICITY",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.profile.ethnicity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFEDF2FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: viewMore,
                      child: const SizedBox(width: 4),
                    ),
                    Expanded(
                      child: AnimatedOpacity(
                        opacity: viewMore ? 1.0 : 0.0,
                        duration: const Duration(
                            milliseconds: 600), // Adjust the duration as needed
                        curve: Curves.easeInOut, // Adjust the curve as needed
                        child: Visibility(
                          visible: viewMore,
                          child: SizedBox(
                            width: double.infinity, // Adjust padding as needed
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30.0), // Adjust the radius
                              ),
                              elevation: 0, // Set the elevation for the card
                              color: const Color(0xFF303E8F),
                              child: Padding(
                                padding: const EdgeInsets.all(28.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // Handle onTap action here
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            "STATUS",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${widget.profile.marital_status}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFEDF2FF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: viewMore,
                  child: const SizedBox(height: 4),
                ),
                AnimatedOpacity(
                  opacity: viewMore ? 1.0 : 0.0,
                  duration: const Duration(
                      milliseconds: 700), // Adjust the duration as needed
                  curve: Curves.easeInOut, // Adjust the curve as needed
                  child: Visibility(
                    visible: viewMore,
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(30.0), // Adjust the radius
                        ),
                        elevation: 0, // Set the elevation for the card
                        color: const Color(0xFF303E8F),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle onTap action here
                                },
                                child: const Row(
                                  children: [
                                    Text(
                                      "OCCUPATION",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.profile.occupation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: viewMore,
                  child: const SizedBox(height: 8),
                ),
                AnimatedOpacity(
                  opacity: viewMore ? 1.0 : 0.0,
                  duration: const Duration(
                      milliseconds: 800), // Adjust the duration as needed
                  curve: Curves.easeInOut, // Adjust the curve as needed
                  child: Visibility(
                    visible: viewMore,
                    child: SizedBox(
                      width: double.infinity, // Adjust padding as needed
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              viewMore = !viewMore;
                              viewLess = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            backgroundColor: const Color(0xFF222E75),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: Color(
                                      0xFFB6CBFF), // Set the color of the icon
                                  size:
                                      20, // Adjust the size of the icon as needed
                                ),
                                Spacer(),
                                Text(
                                  "view less",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.keyboard_arrow_up_rounded,
                                  color: Color(
                                      0xFFB6CBFF), // Set the color of the icon
                                  size:
                                      20, // Adjust the size of the icon as needed
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // // actions

                // const SizedBox(height: 36.0),
                // Container(
                //   margin: const EdgeInsets.symmetric(horizontal: 16),
                //   child: const Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           color: Color(0xFFB6CBFF),
                //           height: 1,
                //         ),
                //       ),
                //       Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 8),
                //         child: Text(
                //           'Actions',
                //           style: TextStyle(
                //               color: Color(0xFFEDF2FF), letterSpacing: 2),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           color: Color(0xFFB6CBFF),
                //           height: 1,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16.0),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //   child: SizedBox(
                //     height: 60.0,
                //     width: double.infinity,
                //     child: ElevatedButton(
                //       onPressed: () {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => SharedAppointments(
                //                 user: widget.user,
                //                 autoImplyLeading: false,
                //                 initialTab: 0,
                //                 profile: widget.profile,
                //                 patientName:
                //                     getFirstTwoWords(widget.profile.name)),
                //           ),
                //         );
                //       },
                //       style: OutlinedButton.styleFrom(
                //         backgroundColor:
                //             const Color(0xFFDBE5FF), // Set the fill color
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(
                //               50.0), // Adjust the value as needed
                //         ),
                //         side: const BorderSide(
                //           color: Color(0xFF6086f6), // Set the outline color
                //           width: 2.5, // Set the outline width
                //         ),
                //       ),
                //       child: const Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Padding(
                //             padding: EdgeInsets.all(
                //                 12.0), // Adjust padding as needed
                //             child: Icon(
                //               Icons.event, // Use any icon you want
                //               color: Color(0xFF1F3299),
                //               size: 24,
                //             ),
                //           ),
                //           Spacer(), // Adjust the spacing between icon and text
                //           Text(
                //             'Shared Appointments',
                //             style: TextStyle(
                //               fontSize: 18,
                //               fontWeight: FontWeight.w500,
                //               color: Color(0xFF1F3299),
                //             ),
                //           ),
                //           Spacer(),
                //           Padding(
                //             padding: EdgeInsets.all(
                //                 12.0), // Adjust padding as needed
                //             child: Icon(
                //               Icons.event, // Use any icon you want
                //               color: Color(0xFF1F3299),
                //               size: 24,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // if (widget.profile.gender == 'Female')
                //   const SizedBox(height: 8.0),
                // if (widget.profile.gender == 'Female')
                //   Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                //     child: SizedBox(
                //       height: 60.0,
                //       width: double.infinity,
                //       child: ElevatedButton(
                //         onPressed: () {
                //           //
                //         },
                //         style: OutlinedButton.styleFrom(
                //           backgroundColor:
                //               const Color(0xFFCBD9FF), // Set the fill color
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(
                //                 50.0), // Adjust the value as needed
                //           ),
                //           side: const BorderSide(
                //             color: Color(0xFF6086f6), // Set the outline color
                //             width: 2.5, // Set the outline width
                //           ),
                //         ),
                //         child: const Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Padding(
                //               padding: EdgeInsets.all(
                //                   12.0), // Adjust padding as needed
                //               child: Icon(
                //                 Icons
                //                     .pregnant_woman_rounded, // Use any icon you want
                //                 color: Color(0xFF1F3299),
                //                 size: 24,
                //               ),
                //             ),
                //             Spacer(), // Adjust the spacing between icon and text
                //             Text(
                //               'Update Maternity',
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w500,
                //                 color: Color(0xFF1F3299),
                //               ),
                //             ),
                //             Spacer(),
                //             Padding(
                //               padding: EdgeInsets.all(
                //                   12.0), // Adjust padding as needed
                //               child: Icon(
                //                 Icons
                //                     .pregnant_woman_rounded, // Use any icon you want
                //                 color: Color(0xFF1F3299),
                //                 size: 24,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // const SizedBox(height: 20.0),
                // ListView.builder(
                //   shrinkWrap: true,
                //   itemCount: _profileInfo.length,
                //   itemBuilder: (context, index) {
                //     Profile profile = _profileInfo[index];
                //     return SizedBox(
                //       width: MediaQuery.of(context)
                //           .size
                //           .width, // Set width to screen width
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           const Text('MATERNITY STATUS',
                //               style: TextStyle(
                //                   fontSize: 14,
                //                   color: Color.fromARGB(255, 121, 121, 121))),
                //           const SizedBox(height: 4),
                //           DropdownButton<String>(
                //             value: _maternityValue,
                //             onChanged: (newValue) {
                //               setState(() {
                //                 _maternityValue = newValue!;
                //                 _handleMaternitySelection(_maternityValue);
                //               });
                //             },
                //             items: <String>[
                //               'No',
                //               'First Trimester',
                //               'Second Trimester',
                //               'Third Trimester'
                //             ].map<DropdownMenuItem<String>>((String value) {
                //               return DropdownMenuItem<String>(
                //                 value: value,
                //                 child: Text(value),
                //               );
                //             }).toList(),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
