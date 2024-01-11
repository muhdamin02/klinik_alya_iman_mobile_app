import 'package:flutter/material.dart';
import 'package:klinik_alya_iman_mobile_app/pages/guest_pages/guest_home.dart';
import '../models/user.dart';
import '../pages/guest_pages/guest_appointment_pages/guest_profile.dart';
import '../pages/startup/login.dart';
import '../services/misc_methods/notification_singleton.dart';
import '../services/notification_service.dart';

class GuestNavigationBar extends StatefulWidget {
  final int currentIndex;
  final User user;

  const GuestNavigationBar({
    Key? key,
    required this.user,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _GuestNavigationBarState createState() => _GuestNavigationBarState();
}

class _GuestNavigationBarState extends State<GuestNavigationBar> {
  int _newIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _getPage(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _newIndex,
          onTap: (index) {
            setState(() {
              _newIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Login',
            ),
          ],
        ),
      ),
    );
  }

  Widget? _getPage() {
    switch (_newIndex) {
      case 0:
        return widget.currentIndex == 0 ? Container() : _buildGuestHome();
      case 1:
        return widget.currentIndex == 1 ? Container() : _buildCreateTempProfile();
      case 2:
        return widget.currentIndex == 2 ? Container() : _buildLogin();
      default:
        return Container(); // Add a default case for safety
    }
  }

  Widget _buildGuestHome() {
    return GuestHome(user: widget.user, showTips: false);
  }

  Widget _buildCreateTempProfile() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTempProfile(user: widget.user),
        ),
      );
    });
    return Container();
  }

  Widget _buildLogin() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationCounter notificationCounter = NotificationCounter();
      notificationCounter.reset();
      NotificationService().cancelAllNotifications();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(
            identificationPlaceholder: '',
            passwordPlaceholder: '',
          ),
        ),
      );
    });

    return Container();
  }
}
