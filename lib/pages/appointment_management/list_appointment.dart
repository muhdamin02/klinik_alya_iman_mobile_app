import 'package:flutter/material.dart';
import '../../app_drawer/app_drawer_profiles_logout_only.dart';
import '../../models/appointment.dart';
import '../../models/profile.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import '../../services/misc_methods/date_display.dart';
import 'appointment_form.dart';
import 'update_appointment.dart';
import 'view_appointment.dart';

class ListAppointment extends StatefulWidget {
  final User user;
  final Profile profile;
  final bool autoImplyLeading;

  const ListAppointment(
      {super.key,
      required this.user,
      required this.profile,
      required this.autoImplyLeading});

  @override
  // ignore: library_private_types_in_public_api
  _ListAppointmentState createState() => _ListAppointmentState();
}

// ----------------------------------------------------------------------

class _ListAppointmentState extends State<ListAppointment> {
  List<Appointment> _appointmentList = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentList();
  }

  // ----------------------------------------------------------------------
  // Get list of appointments

  Future<void> _fetchAppointmentList() async {
    List<Appointment> appointmentList = await DatabaseService()
        .appointment(widget.user.user_id!, widget.profile.profile_id);
    setState(() {
      _appointmentList = appointmentList;
    });
  }
  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // View Appointment

  void _viewAppointment(Appointment appointment) {
    // Navigate to the view appointment details page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ViewAppointment(appointment: appointment, user: widget.user),
      ),
    );
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Update Appointment

  void _updateAppointment(Appointment appointment) {
    // Navigate to the update appointment page with the selected appointment
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAppointment(
          appointment: appointment,
          reschedulerIsPatient: true,
        ),
      ),
    ).then((result) {
      if (result == true) {
        // If the appointment was updated, refresh the appointment list
        _fetchAppointmentList();
      }
    });
  }

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Cancel Appointment

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
                  _fetchAppointmentList();
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

  // ----------------------------------------------------------------------

  // ----------------------------------------------------------------------
  // Delete Appointment

  void _deleteAppointment(int? appointmentId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Appointment'),
          content: const Text(
              'Are you sure you want to remove this appointment from history?'),
          actions: <Widget>[
            ElevatedButton(
              child:
                  const Text('Remove', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // Call the deleteAppointment method and pass the appointmentId
                await DatabaseService().deleteAppointment(appointmentId!);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                // Refresh the appointment history
                _fetchAppointmentList();
              },
            ),
            ElevatedButton(
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------------------
  // Builder

  @override
  Widget build(BuildContext context) {
    // Sort the _bookingHistory list by appointment date
    _appointmentList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    return WillPopScope(
      onWillPop: () async {
        return widget.autoImplyLeading;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Appointments'),
        ),
        drawer: AppDrawerProfilesLogout(
          header: 'Appointments',
          user: widget.user,
          profile: widget.profile,
          autoImplyLeading: widget.autoImplyLeading,
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: _appointmentList.length,
              itemBuilder: (context, index) {
                Appointment appointment = _appointmentList[index];
                return Column(
                  children: [
                    const SizedBox(height: 16.0),
                    ListTile(
                      title: Text(
                          '${appointment.appointment_time} - ${DateDisplay(date: appointment.appointment_date).getStringDate()}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4.0),
                          Text('Status: ${appointment.status}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Call a method to handle the view functionality
                              _viewAppointment(appointment);
                            },
                          ),
                          Visibility(
                            visible: appointment.status != 'Cancelled' &&
                                appointment.status != 'Confirmed',
                            child: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                // Call a method to handle the update functionality
                                _updateAppointment(appointment);
                              },
                            ),
                          ),
                          Visibility(
                            visible: appointment.status != 'Cancelled',
                            child: IconButton(
                              icon: const Icon(Icons.not_interested_rounded),
                              onPressed: () {
                                // Call a method to handle the cancel functionality
                                _cancelAppointment(appointment);
                              },
                            ),
                          ),
                          Visibility(
                            visible: appointment.status == 'Cancelled',
                            child: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                // Call a method to handle the delete functionality
                                _deleteAppointment(appointment.appointment_id);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to the page where you want to appointment form
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentForm(
                  user: widget.user,
                  profile: widget.profile,
                ),
              ),
            );
          },
          icon: const Icon(Icons.event),
          label: const Text('Book New Appointment'),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
