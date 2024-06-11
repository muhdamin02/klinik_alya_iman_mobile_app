// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import '../../services/misc_methods/get_first_two_words.dart';
import '../../services/misc_methods/notification_singleton.dart';
import '../../services/misc_methods/show_hovering_message.dart';
import '../../services/notification_service.dart';
import '../medication_management/list_medication.dart';
import '../practitioner_pages/manage_appointment.dart';
import '../practitioner_pages/patient_pages/view_patient.dart';
import '../practitioner_pages/patient_pages/view_patients_list.dart';
import '../practitioner_pages/practitioner_home.dart';
import '../practitioner_pages/practitioner_profile_page.dart';
import '../practitioner_pages/shared_appointments.dart';
import '../profile_management/profile_page.dart';
import '../startup/login.dart';
import '../startup/patient_homepage.dart';
import '../system_admin_pages/admin_appt_management/admin_appt_management.dart';
import '../system_admin_pages/admin_appt_management/appointment_by_practitioner.dart';
import '../system_admin_pages/admin_appt_management/view_patient_admin.dart';
import '../system_admin_pages/system_admin_home.dart';
import '../system_admin_pages/user_management/manage_user.dart';
import '../system_admin_pages/user_management/view_user.dart';
import 'assign_practitioner.dart';
import 'list_appointment.dart';
import 'update_appointment.dart';

class ViewAppointment extends StatefulWidget {
  final Appointment appointment;
  final User actualUser;
  final User viewedUser;
  final Profile profile;
  final bool autoImplyLeading;
  final bool sharedAppointments;
  final bool appointmentByPractitioner;

  const ViewAppointment({
    Key? key,
    required this.appointment,
    required this.viewedUser,
    required this.actualUser,
    required this.profile,
    required this.autoImplyLeading,
    required this.sharedAppointments,
    required this.appointmentByPractitioner,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewAppointmentState createState() => _ViewAppointmentState();
}

class _ViewAppointmentState extends State<ViewAppointment> {
  List<Appointment> _appointmentInfo = [];
  List<User> _practitionerList = [];
  List<User> _practitionerInfo = [];
  List<Profile> _patientInfo = [];
  String? _patientName, _practitionerName;
  User? _selectedPractitioner;
  bool viewEditButtonForSystemAdmin = false;
  bool viewConfirmButtonForPractitioner = false;
  bool viewAttendanceButtons = false;
  bool viewEditButtonForPractitioner = false;
  bool viewEditButtonForPatient = false;
  bool viewCancelButton = true;

  @override
  void initState() {
    super.initState();
    _fetchAppointmentInfo();
    _loadPatientName();
  }

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _fetchAppointmentInfo() async {
    List<Appointment> appointmentInfo = await DatabaseService()
        .appointmentInfo(widget.appointment.appointment_id);
    setState(() {
      _appointmentInfo = appointmentInfo;
      if (_appointmentInfo.isNotEmpty) {
        // Call _getPractitionerName with the practitioner_id from the first appointment in the list
        _getPractitionerName(_appointmentInfo[0].practitioner_id);
        _getPractitionerInfo(_appointmentInfo[0].practitioner_id);
        _getPatientInfo(_appointmentInfo[0].profile_id!);
        print(_appointmentInfo[0].appointment_time);
        if (widget.actualUser.role.toLowerCase() == 'systemadmin' &&
            _appointmentInfo[0].practitioner_id != 0) {
          viewEditButtonForSystemAdmin = true;
        }
        if (widget.actualUser.role.toLowerCase() == 'practitioner' &&
            _appointmentInfo[0].status == 'Assigned') {
          viewConfirmButtonForPractitioner = true;
          viewEditButtonForPractitioner = true;
        }
        if (widget.actualUser.role.toLowerCase() == 'practitioner' &&
            _appointmentInfo[0].status == 'Updated') {
          viewConfirmButtonForPractitioner = true;
          viewEditButtonForPractitioner = true;
        }
        if (widget.actualUser.role.toLowerCase() == 'practitioner' &&
            _appointmentInfo[0].status == 'Confirmed' &&
            isAppointmentTodayOrPast(_appointmentInfo[0].appointment_date)) {
          viewAttendanceButtons = true;
          viewEditButtonForPractitioner = true;
          viewCancelButton = false;
        }
        if (widget.actualUser.role.toLowerCase() == 'patient' &&
            _appointmentInfo[0].status == 'Pending') {
          viewEditButtonForPatient = true;
        }
        if (widget.actualUser.role.toLowerCase() == 'patient' &&
            _appointmentInfo[0].status == 'Confirmed' &&
            isAppointmentTodayOrPast(_appointmentInfo[0].appointment_date)) {
          viewEditButtonForPatient = false;
          viewCancelButton = false;
        }
        if (_appointmentInfo[0].status == 'Cancelled') {
          viewCancelButton = false;
        }
        _getPractitionerList(_appointmentInfo[0].branch);
      }
    });
  }
  // ----------------------------------------------------------------------

  bool isAppointmentTodayOrPast(String appointmentDate) {
    try {
      // Trim the appointment date string
      appointmentDate = appointmentDate.trim();

      // Parse the appointment date
      DateTime parsedDate = DateTime.parse(appointmentDate);

      // Get the current date (without time)
      DateTime currentDate = DateTime.now();
      currentDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);

      // Compare the appointment date with the current date
      // Return true if the appointment date is today or in the past
      return parsedDate.isBefore(currentDate) ||
          parsedDate.isAtSameMomentAs(currentDate);
    } catch (e) {
      print('Error parsing date: $e');
      return false; // Return false if there's an error
    }
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Fetch details

  Future<void> _getPractitionerList(String appointmentBranch) async {
    List<User> practitionerList =
        await DatabaseService().getPractitionersByBranch(appointmentBranch);
    setState(() {
      _practitionerList = practitionerList;
    });
  }
  //

  // ----------------------------------------------------------------------
  // load patient name
  Future<void> _loadPatientName() async {
    _patientName =
        await DatabaseService().getPatientName(widget.appointment.profile_id);
    setState(() {}); // Update the UI to display the patient name
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // load practitioner name
  Future<void> _getPractitionerName(practitionerId) async {
    if (practitionerId != 0) {
      String? practitionerName =
          await DatabaseService().getUserName(practitionerId);
      setState(() {
        _practitionerName = practitionerName;
      });
    } else {
      setState(() {
        _practitionerName = 'Not yet assigned';
      });
    }
  }
  // ----------------------------------------------------------------------

  Future<void> _getPractitionerInfo(int practitionerId) async {
    List<User> practitionerInfo =
        await DatabaseService().userInfo(practitionerId);
    setState(() {
      _practitionerInfo = practitionerInfo;
    });
  }

  Future<void> _getPatientInfo(int profileId) async {
    List<Profile> patientInfo = await DatabaseService().profileInfo(profileId);
    setState(() {
      _patientInfo = patientInfo;
    });
  }

  // ----------------------------------------------------------------------

  Future<void> launchMap(double lat, double long, String branch) async {
    try {
      final coords = Coords(lat, long); // Coordinates of the marker
      final title = branch; // Title of the marker
      const description = 'Clinic'; // Description of the marker

      final isGoogleMapsAvailable =
          await MapLauncher.isMapAvailable(MapType.google);

      if (isGoogleMapsAvailable ?? false) {
        await MapLauncher.showMarker(
          mapType: MapType.google,
          coords: coords,
          title: title,
          description: description,
        );
      } else {
        print('Google Maps is not available.');
      }
    } catch (e) {
      print('Error launching map: $e');
    }
  }

  // --------------------------------------------------------------------

  void _confirmAppointment(Appointment appointment) {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    String practitionerName = widget.actualUser.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Confirm Appointment'),
          content:
              const Text('Are you sure you want to confirm this appointment?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () async {
                status = 'Confirmed';
                remarks =
                    'The appointment has been confirmed by $practitionerName at at ${DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now())}.';
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().updateAppointmentStatus(
                    appointment.appointment_id!, status, remarks);
                Navigator.of(context).pop();
                setState(() {
                  _fetchAppointmentInfo();
                  viewConfirmButtonForPractitioner = false;
                });
              },
            ),
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------

  void _attendAppointment(Appointment appointment) {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    String practitionerName = widget.actualUser.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Mark as Attended'),
          content: const Text(
              'Are you sure you want to mark this appointment as attended?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () async {
                status = 'Attended';
                remarks =
                    'The appointment has been marked as attended by $practitionerName at at ${DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now())}.';
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().updateAppointmentStatus(
                    appointment.appointment_id!, status, remarks);
                Navigator.of(context).pop();
                setState(() {
                  _fetchAppointmentInfo();
                });
              },
            ),
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------

  void _absentAppointment(Appointment appointment) {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    String practitionerName = widget.actualUser.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Mark as Absent'),
          content: const Text(
              'Are you sure you want to mark this appointment as absent?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () async {
                status = 'Absent';
                remarks =
                    'The appointment has been marked as absent by $practitionerName at at ${DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now())}.';
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().updateAppointmentStatus(
                    appointment.appointment_id!, status, remarks);
                Navigator.of(context).pop();
                setState(() {
                  _fetchAppointmentInfo();
                });
              },
            ),
            TextButton(
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------------

  void _leaveRemarks(Appointment appointment) async {
    TextEditingController remarksController = TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String userRemarks;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Leave Remarks'),
          content: Builder(
            builder: (BuildContext context) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: remarksController,
                      decoration: const InputDecoration(
                        hintText: 'Enter remarks...',
                        hintStyle: TextStyle(color: Color(0xFFB6CBFF)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color(
                                  0xFFB6CBFF)), // Set the color of the underline
                        ),
                      ),
                      style: const TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter remarks.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (widget.actualUser.role.toLowerCase() == 'patient') {
                    userRemarks = remarksController.text;
                    await DatabaseService()
                        .leaveRemarksAsPatient(appointmentId!, userRemarks);
                  } else if (widget.actualUser.role.toLowerCase() ==
                      'practitioner') {
                    userRemarks = remarksController.text;
                    await DatabaseService().leaveRemarksAsPractitioner(
                        appointmentId!, userRemarks);
                  } else {
                    return;
                  }
                  Navigator.pop(context); // Close the dialog
                  _fetchAppointmentInfo();
                }
              },
              child: const Text('Confirm',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFFEDF2FF))),
            ),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

// --------------------

  void _cancelAppointment(Appointment appointment) {
    TextEditingController cancellationReasonController =
        TextEditingController();
    final int? appointmentId = appointment.appointment_id;
    String status = appointment.status;
    String systemRemarks = appointment.system_remarks;
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Appointment'),
          content: Builder(
            builder: (BuildContext context) {
              return Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Reason for Cancellation:',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextFormField(
                      controller: cancellationReasonController,
                      decoration: const InputDecoration(
                        hintText: 'Enter reason...',
                      ),
                      style: const TextStyle(fontSize: 15),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a reason';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Proceed with cancellation
                  status = 'Cancelled';
                  systemRemarks =
                      'The appointment has been cancelled by the patient.';
                  systemRemarks = cancellationReasonController.text;
                  await DatabaseService().updateAppointmentStatus(
                      appointmentId!, status, systemRemarks);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                  setState(() {
                    _fetchAppointmentInfo();
                    viewEditButtonForPractitioner = false;
                    viewConfirmButtonForPractitioner = false;
                    viewEditButtonForSystemAdmin = false;
                    viewAttendanceButtons = false;
                    viewCancelButton = false;
                  });
                }
              },
              child: const Text('Confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // ----------------

  void _handlePractitionerSelection(
      practitionerId, Appointment appointment) async {
    String status = appointment.status;
    String remarks = appointment.system_remarks;
    print(
        'Selected Practitioner: ${_selectedPractitioner?.user_id} ${_selectedPractitioner?.name}');

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF303E8F),
          title: const Text('Assign Practitioner',
              style: TextStyle(color: Color(0xFFFFD271))),
          content: Builder(
            builder: (BuildContext context) {
              return Text(
                  'Are you sure you want to assign ${_selectedPractitioner?.name} to this appointment?',
                  style: const TextStyle(height: 1.5));
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  await DatabaseService().assignAppointmentPractitioner(
                      widget.appointment.appointment_id!, practitionerId);
                  status = 'Assigned';
                  remarks =
                      'The appointment has been assigned to practitioner ${_selectedPractitioner?.name} at ${DateFormat('yyyy-MM-dd, h:mm a').format(DateTime.now())}.';
                  // Call the deleteAppointment method and pass the appointmentId
                  await DatabaseService().updateAppointmentStatus(
                      appointment.appointment_id!, status, remarks);
                  Navigator.pop(context);
                  // Refresh the appointment
                  setState(() {
                    _fetchAppointmentInfo();
                  });
                },
                child: const Text('Confirm',
                    style: TextStyle(color: Color(0xFFEDF2FF)))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Color(0xFFEDF2FF)))),
          ],
        );
      },
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Appointment'),
          automaticallyImplyLeading: widget.autoImplyLeading,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                // Show a dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color(0xFF303E8F),
                      title: const Text('Confirm Logout'),
                      content: const Text('Are you sure you want to log out?',
                          style: TextStyle(color: Color(0xFFEDF2FF))),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            // Perform logout actions
                            NotificationCounter notificationCounter =
                                NotificationCounter();
                            notificationCounter.reset();
                            await NotificationService()
                                .cancelAllNotifications();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Login(
                                  usernamePlaceholder:
                                      widget.actualUser.username,
                                  passwordPlaceholder:
                                      widget.actualUser.password,
                                ),
                              ),
                            );
                          },
                          child: const Text('Yes',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('No',
                              style: TextStyle(color: Color(0xFFEDF2FF))),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: 56.0, // Adjust the height as needed
          child: BottomAppBar(
            color: const Color(
              0xFF0A0F2C,
            ), // Set the background color of the BottomAppBar
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  if (widget.actualUser.role == 'systemadmin') ...[
                    const Spacer(),
                    if (widget.appointmentByPractitioner)
                      IconButton(
                        icon: const Icon(Icons.event),
                        iconSize: 22,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageAppointmentAdmin(
                                user: widget.actualUser,
                                autoImplyLeading: false,
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFEDF2FF,
                        ), // Set the color of the icon
                      ),
                    if (!widget.appointmentByPractitioner)
                      IconButton(
                        icon: const Icon(Icons.event),
                        iconSize: 22,
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageAppointmentAdmin(
                                user: widget.actualUser,
                                autoImplyLeading: false,
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFFFD271,
                        ), // Set the color of the icon
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.home),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SystemAdminHome(
                              user: widget.actualUser,
                            ),
                          ),
                        );
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                    const Spacer(),
                    if (!widget.appointmentByPractitioner)
                      IconButton(
                        icon: const Icon(Icons.group),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewUser(
                                viewedUser: widget.viewedUser,
                                actualUser: widget.actualUser,
                                autoImplyLeading: false,
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFEDF2FF,
                        ), // Set the color of the icon
                      ),
                    if (widget.appointmentByPractitioner)
                      IconButton(
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentByPractitioner(
                                viewedUser: widget.viewedUser,
                                autoImplyLeading: false,
                                actualUser: widget.actualUser,
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFFFD271,
                        ),
                      ),
                    const Spacer(),
                  ] else if (widget.actualUser.role == 'practitioner') ...[
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PractitionerProfilePage(
                              actualUser: widget.actualUser,
                              practitionerUser: widget.actualUser,
                              autoImplyLeading: false,
                            ),
                          ),
                        );
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                    const Spacer(),
                    if (widget.sharedAppointments)
                      IconButton(
                        icon: const Icon(Icons.event),
                        iconSize: 22,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageAppointment(
                                  user: widget.actualUser,
                                  autoImplyLeading: false,
                                  initialTab: 1,
                                  profileId: 0),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFEDF2FF,
                        ), // Set the color of the icon
                      ),
                    if (!widget.sharedAppointments)
                      IconButton(
                        icon: const Icon(Icons.event),
                        iconSize: 22,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ManageAppointment(
                                  user: widget.actualUser,
                                  autoImplyLeading: false,
                                  initialTab: 1,
                                  profileId: 0),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFFFD271,
                        ), // Set the color of the icon
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.home),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PractitionerHome(
                              user: widget.actualUser,
                            ),
                          ),
                        );
                      },
                      color: const Color(
                        0xFFEDF2FF,
                      ), // Set the color of the icon
                    ),
                    const Spacer(),
                    if (widget.sharedAppointments)
                      IconButton(
                        icon: const Icon(Icons.list),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SharedAppointments(
                                user: widget.actualUser,
                                autoImplyLeading: false,
                                initialTab: 0,
                                profile: _patientInfo[0],
                                patientName:
                                    getFirstTwoWords(widget.profile.name),
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFFFD271,
                        ), // Set the color of the icon
                      ),
                    if (!widget.sharedAppointments)
                      IconButton(
                        icon: const Icon(Icons.group),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PatientsList(
                                user: widget.actualUser,
                                autoImplyLeading: false,
                              ),
                            ),
                          );
                        },
                        color: const Color(
                          0xFFEDF2FF,
                        ), // Set the color of the icon
                      ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      iconSize: 23,
                      onPressed: () {},
                      color:
                          const Color(0xFFEDF2FF), // Set the color of the icon
                    ),
                    const Spacer(),
                  ] else if (widget.actualUser.role == 'patient') ...[
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              user: widget.actualUser,
                              profile: widget.profile,
                              autoImplyLeading: false,
                            ),
                          ),
                        );
                      },
                      color:
                          const Color(0xFFEDF2FF), // Set the color of the icon
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.event),
                      iconSize: 22,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListAppointment(
                              user: widget.actualUser,
                              profile: widget.profile,
                              autoImplyLeading: false,
                              initialTab: 1,
                            ),
                          ),
                        );
                      },
                      color:
                          const Color(0xFFFFD271), // Set the color of the icon
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.home),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientHomepage(
                              user: widget.actualUser,
                              profile: widget.profile,
                              hasProfiles: true,
                              hasChosenProfile: true,
                              autoImplyLeading: false,
                            ),
                          ),
                        );
                      },
                      color:
                          const Color(0xFFEDF2FF), // Set the color of the icon
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.medication),
                      iconSize: 25,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListMedication(
                              user: widget.actualUser,
                              profile: widget.profile,
                              autoImplyLeading: false,
                            ),
                          ),
                        );
                      },
                      color:
                          const Color(0xFFEDF2FF), // Set the color of the icon
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      iconSize: 23,
                      onPressed: () {},
                      color:
                          const Color(0xFFEDF2FF), // Set the color of the icon
                    ),
                    const Spacer(),
                  ]
                ],
              ),
            ),
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          shrinkWrap: true,
          itemCount: _appointmentInfo.length,
          itemBuilder: (context, index) {
            Appointment appointment = _appointmentInfo[index];
            return SizedBox(
              width: MediaQuery.of(context)
                  .size
                  .width, // Set width to screen width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            'Reference Number',
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
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: appointment.random_id));
                          showHoveringMessage(
                              context, 'Copied to clipboard', 0.19, 0.25, 0.5);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF2B3885), // Background color of the ElevatedButton
                          elevation: 0, // Set the elevation for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                appointment.random_id,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24,
                                  letterSpacing: 8,
                                  color: Color(0xFFFFD271),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
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
                            'Appointment Details',
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.actualUser.role == 'patient') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                  user: widget.actualUser,
                                  profile: widget.profile,
                                  autoImplyLeading: true,
                                ),
                              ),
                            );
                          } else if (widget.actualUser.role == 'practitioner') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPatient(
                                  user: widget.actualUser,
                                  profile: _patientInfo[0],
                                  autoImplyLeading: true,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewPatientAdmin(
                                  user: widget.actualUser,
                                  profile: _patientInfo[0],
                                  autoImplyLeading: true,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF303E8F), // Background color of the ElevatedButton
                          elevation: 0, // Set the elevation for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Handle onTap action here
                                },
                                child: const Text(
                                  "PATIENT",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Color(0xFFB6CBFF),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_patientName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF3848A1),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Text(
                                      "DATE",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    DateDisplay(
                                            date: appointment.appointment_date)
                                        .getStringDate(),
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
                                  20.0), // Adjust the radius
                            ),
                            elevation: 0, // Set the elevation for the card
                            color: const Color(0xFF3848A1),
                            child: Padding(
                              padding: const EdgeInsets.all(28.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Handle onTap action here
                                    },
                                    child: const Text(
                                      "TIME",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                        color: Color(0xFFB6CBFF),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    appointment.appointment_time,
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
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.actualUser.role.toLowerCase() ==
                              'systemadmin') {
                            if (!widget.appointmentByPractitioner) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignPractitioner(
                                    appointment: appointment,
                                    user: widget.actualUser,
                                    practitionerId: appointment.practitioner_id,
                                  ),
                                ),
                              );
                            }
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       backgroundColor: const Color(0xFF303E8F),
                            //       title: const Text('Choose Practitioner'),
                            //       content: SizedBox(
                            //         height: 60,
                            //         child: DropdownButton<User>(
                            //           dropdownColor: const Color(0xFF303E8F),
                            //           value: _selectedPractitioner,
                            //           items: _practitionerList.map((User user) {
                            //             return DropdownMenuItem<User>(
                            //               value: user,
                            //               child: Container(
                            //                 constraints: const BoxConstraints(
                            //                   maxWidth:
                            //                       200, // Adjust the maxWidth as needed
                            //                 ),
                            //                 child: Text(
                            //                   user.name,
                            //                   style: const TextStyle(
                            //                     color: Color(0xFFEDF2FF),
                            //                   ),
                            //                   softWrap:
                            //                       true, // Allows text to wrap to the next line
                            //                 ),
                            //               ),
                            //             );
                            //           }).toList(),
                            //           onChanged: (User? newValue) {
                            //             setState(() {
                            //               Navigator.of(context).pop();
                            //               _selectedPractitioner = newValue;
                            //               _handlePractitionerSelection(
                            //                   _selectedPractitioner!.user_id,
                            //                   appointment);
                            //             });
                            //           },
                            //         ),
                            //       ),
                            //     );
                            //   },
                            // );
                          } else {
                            if (_practitionerName == 'Not yet assigned') {
                              showHoveringMessage(
                                  context,
                                  'The practitioner has not been assigned yet',
                                  0.82,
                                  0.15,
                                  0.7);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PractitionerProfilePage(
                                    actualUser: widget.actualUser,
                                    practitionerUser: _practitionerInfo[0],
                                    autoImplyLeading: true,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF4151B1), // Background color of the ElevatedButton
                          elevation: 0, // Set the elevation for the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the radius
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisSize:
                                    MainAxisSize.min, // Center the Row content
                                children: [
                                  const Text(
                                    'PRACTITIONER',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Color(0xFFB6CBFF),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        widget.actualUser.role.toLowerCase() ==
                                                'systemadmin' &&
                                            !widget.appointmentByPractitioner,
                                    child: const SizedBox(width: 8.0),
                                  ),
                                  Visibility(
                                    visible:
                                        widget.actualUser.role.toLowerCase() ==
                                                'systemadmin' &&
                                            !widget.appointmentByPractitioner,
                                    child: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFFFD271),
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$_practitionerName',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF3848A1), // Background color of the ElevatedButton
                                elevation:
                                    0, // Set the elevation for the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Text(
                                        "STATUS",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: Color(0xFFB6CBFF),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      appointment.status,
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
                      const SizedBox(width: 4),
                      Expanded(
                        child: SizedBox(
                          width: double.infinity, // Adjust padding as needed
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ElevatedButton(
                              onPressed: () {
                                switch (appointment.branch) {
                                  case 'Karang Darat':
                                    launchMap(
                                        3.9112965679321294,
                                        103.34899018744197,
                                        'Klinik Alya Iman - Karang Darat');
                                    break;
                                  case 'Kemaman':
                                    launchMap(
                                        4.257055848607369,
                                        103.40434944427868,
                                        'Klinik Alya Iman - Kemaman');
                                    break;
                                  case 'Inderapura':
                                    launchMap(
                                        3.7511729280328034,
                                        103.26166483677974,
                                        'Klinik Alya Iman - Inderapura');
                                    break;
                                  default:
                                    print('map doesnt work');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                    0xFF3848A1), // Background color of the ElevatedButton
                                elevation:
                                    0, // Set the elevation for the button
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Adjust the radius
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 28.0, horizontal: 14.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "BRANCH",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: Color(0xFFB6CBFF),
                                            ),
                                          ),
                                          SizedBox(width: 8.0),
                                          Icon(
                                            Icons.fmd_good,
                                            color: Color(0xFFB6CBFF),
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      appointment.branch,
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
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity, // Adjust padding as needed
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF303E8F),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                'REMARKS BY SYSTEM',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              appointment.system_remarks,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
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
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF3848A1),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                'REMARKS BY PATIENT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              appointment.patient_remarks,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
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
                            BorderRadius.circular(20.0), // Adjust the radius
                      ),
                      elevation: 0, // Set the elevation for the card
                      color: const Color(0xFF4151B1),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Handle onTap action here
                              },
                              child: const Text(
                                'REMARKS BY PRACTITIONER',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFB6CBFF),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              appointment.practitioner_remarks,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Color(0xFFEDF2FF),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
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
                            'Actions',
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
                  const SizedBox(height: 20.0),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _attendAppointment(appointment);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons
                                      .event_available, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Mark as Attended',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons
                                      .event_available, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _absentAppointment(appointment);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.event_busy, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Mark as Absent',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons
                                      .event_busy_rounded, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.delete, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Void Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.delete, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewAttendanceButtons,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewConfirmButtonForPractitioner,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _confirmAppointment(appointment);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons
                                      .check_box_rounded, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Confirm Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons
                                      .check_box_rounded, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewConfirmButtonForPractitioner,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewEditButtonForPractitioner,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            int branch;

                            switch (appointment.branch) {
                              case 'Karang Darat':
                                branch = 0;
                                break;
                              case 'Inderapura':
                                branch = 1;
                                break;
                              case 'Kemaman':
                                branch = 2;
                                break;
                              default:
                                branch = 0;
                            }

                            // Navigate to the update appointment page with the selected appointment
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAppointment(
                                  appointment: appointment,
                                  rescheduler: widget.actualUser.role,
                                  appointmentBranch: branch,
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                // If the appointment was updated, refresh the appointment history
                                _fetchAppointmentInfo();
                                _loadPatientName();
                                _getPractitionerList(appointment.branch);
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Edit Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewEditButtonForPractitioner,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewEditButtonForPatient,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            int branch;

                            switch (appointment.branch) {
                              case 'Karang Darat':
                                branch = 0;
                                break;
                              case 'Inderapura':
                                branch = 1;
                                break;
                              case 'Kemaman':
                                branch = 2;
                                break;
                              default:
                                branch = 0;
                            }

                            // Navigate to the update appointment page with the selected appointment
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAppointment(
                                  appointment: appointment,
                                  rescheduler: widget.actualUser.role,
                                  appointmentBranch: branch,
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                // If the appointment was updated, refresh the appointment history
                                _fetchAppointmentInfo();
                                _loadPatientName();
                                _getPractitionerList(appointment.branch);
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Edit Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewEditButtonForPatient,
                    child: const SizedBox(height: 10),
                  ),
                  if (widget.actualUser.role.toLowerCase() != 'systemadmin')
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _leaveRemarks(widget.appointment);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.rate_review, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Leave Remarks',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.rate_review, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (widget.actualUser.role.toLowerCase() != 'systemadmin')
                    const SizedBox(height: 10),
                  Visibility(
                    visible: viewEditButtonForSystemAdmin,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            int branch;

                            switch (appointment.branch) {
                              case 'Karang Darat':
                                branch = 0;
                                break;
                              case 'Inderapura':
                                branch = 1;
                                break;
                              case 'Kemaman':
                                branch = 2;
                                break;
                              default:
                                branch = 0;
                            }

                            // Navigate to the update appointment page with the selected appointment
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateAppointment(
                                  appointment: appointment,
                                  rescheduler: widget.actualUser.role,
                                  appointmentBranch: branch,
                                ),
                              ),
                            ).then((result) {
                              if (result == true) {
                                // If the appointment was updated, refresh the appointment history
                                _fetchAppointmentInfo();
                                _loadPatientName();
                                _getPractitionerList(appointment.branch);
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFFDBE5FF), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFF6086f6), // Set the outline color
                              width: 2.5, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Edit Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1F3299),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.edit, // Use any icon you want
                                  color: Color(0xFF1F3299),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: viewEditButtonForSystemAdmin,
                    child: const SizedBox(height: 10),
                  ),
                  Visibility(
                    visible: viewCancelButton,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _cancelAppointment(appointment);
                          },
                          style: OutlinedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color(0xFF0B1655), // Set the fill color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50.0), // Adjust the value as needed
                            ),
                            side: const BorderSide(
                              color: Color(0xFFC1D3FF), // Set the outline color
                              width: 3, // Set the outline width
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.highlight_off, // Use any icon you want
                                  color: Color(0xFFC1D3FF),
                                  size: 28,
                                ),
                              ),
                              Spacer(), // Adjust the spacing between icon and text
                              Text(
                                'Cancel Appointment',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFFC1D3FF),
                                ),
                              ),
                              Spacer(),
                              Padding(
                                padding: EdgeInsets.all(
                                    12.0), // Adjust padding as needed
                                child: Icon(
                                  Icons.highlight_off, // Use any icon you want
                                  color: Color(0xFFC1D3FF),
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
