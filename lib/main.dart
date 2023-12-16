import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'pages/startup/login.dart';
import 'services/misc_methods/page_transition.dart';
import 'services/notification_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    WidgetsFlutterBinding.ensureInitialized();
    NotificationService().initNotification();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Klinik Alya Iman',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFF32a3cb,
            <int, Color>{
              50: Color(0xFF32a3cb),
              100: Color(0xFF32a3cb),
              200: Color(0xFF32a3cb),
              300: Color(0xFF32a3cb),
              400: Color(0xFF32a3cb),
              500: Color(0xFF32a3cb),
              600: Color(0xFF32a3cb),
              700: Color(0xFF32a3cb),
              800: Color(0xFF32a3cb),
              900: Color(0xFF32a3cb),
            },
          ),
        ).copyWith(
          primary: const Color(0xFF32a3cb),
          secondary: const Color(0xFF32a3cb),
        ),
        textTheme: const TextTheme(
          // booking history details text
          bodyMedium: TextStyle(
            fontFamily: 'Afacad',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),

          // validator texts
          bodySmall: TextStyle(
            fontFamily: 'Afacad',
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),

          // submit and update button
          labelLarge: TextStyle(
            fontFamily: 'Afacad',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),

          // appbar
          titleLarge: TextStyle(
            fontFamily: 'Afacad',
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),

          // placeholder text in textfields, checkbox tiles, dropdown options
          titleMedium: TextStyle(
            fontFamily: 'Afacad',
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
      ),
      home: const Login(
        usernamePlaceholder: '',
        passwordPlaceholder: '',
      ),
    );
  }
}
