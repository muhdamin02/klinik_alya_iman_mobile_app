import 'package:flutter/material.dart';

import '../../app_drawer/app_drawer_logout.dart';
import '../../models/appointment.dart';
import '../../models/user.dart';
import '../../services/database_service.dart';
import 'manage_appointment.dart';
import 'patient_pages/view_patients_list.dart';

class PractitionerHome extends StatefulWidget {
  final User user;

  const PractitionerHome({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _PractitionerHomeState createState() => _PractitionerHomeState();
}

class _PractitionerHomeState extends State<PractitionerHome> {
  List<Appointment> _appointmentTodayList = [];
  List<Appointment> _patientsUnderCareList = [];

  @override
  void initState() {
    super.initState();
    _fetchAppointmentTodayList();
    _fetchPatientsUnderCareList();
    print(_appointmentTodayList);
    print(_patientsUnderCareList);
  }

  // ----------------------------------------------------------------------
  // Get list of today appointments

  Future<void> _fetchAppointmentTodayList() async {
    List<Appointment> appointmentTodayList = await DatabaseService()
        .appointmentTodayPractitioner(widget.user.user_id!);

    // Sort the list by appointment date in ascending order
    appointmentTodayList
        .sort((a, b) => a.appointment_date.compareTo(b.appointment_date));

    setState(() {
      _appointmentTodayList = appointmentTodayList;
    });
  }

  // ----------------------------------------------------------------------
  // Get list of patients under care

  Future<void> _fetchPatientsUnderCareList() async {
    List<Appointment> patientsUnderCareList =
        await DatabaseService().patientsUnderCare(widget.user.user_id!);

    setState(() {
      _patientsUnderCareList = patientsUnderCareList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Return false to prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        drawer: AppDrawerLogout(
          header: 'Practitioner Home',
          user: widget.user,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Adjust the radius
                  ),
                  elevation: 8.0, // You can adjust the elevation as needed
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('APPOINTMENTS TODAY',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 16.0),
                        Text(
                          '${_appointmentTodayList.length}',
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          height: 60.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 115, 176, 255),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      25.0), // Set the value to 0 for a sharp corner
                                  bottomRight: Radius.circular(
                                      25.0), // Set the value to 0 for a sharp corner
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManageAppointment(
                                    user: widget.user,
                                    autoImplyLeading: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text('View Appointments',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          // Add more details specific to practitioners
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(25.0), // Adjust the radius
                  ),
                  elevation: 8.0, // You can adjust the elevation as needed
                  color: const Color.fromARGB(255, 238, 238, 238),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('PATIENTS UNDER CARE',
                            style: TextStyle(fontSize: 20)),
                        const SizedBox(height: 16.0),
                        Text(
                          '${_patientsUnderCareList.length}',
                          style: const TextStyle(fontSize: 64),
                        ),
                        const SizedBox(height: 24.0),
                        SizedBox(
                          height: 60.0,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 115, 176, 255),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      25.0), // Set the value to 0 for a sharp corner
                                  bottomRight: Radius.circular(
                                      25.0), // Set the value to 0 for a sharp corner
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientsList(
                                    user: widget.user,
                                    autoImplyLeading: true,
                                  ),
                                ),
                              );
                            },
                            child: const Text('View Patients',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          // Add more details specific to practitioners
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
