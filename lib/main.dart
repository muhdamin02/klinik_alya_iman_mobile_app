import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klinik_alya_iman_mobile_app/pages/startup/login.dart';
import 'package:timezone/data/latest.dart' as tz;
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
        textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xFFB6CBFF),
            selectionHandleColor: Color(0xFFB6CBFF)),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
                color: Color(0xFFB6CBFF),
                width:
                    2.0), // Set the color and width of the border when focused
            borderRadius: BorderRadius.circular(25.0), // Set the border radius
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF0B1655),
        textTheme: const TextTheme(
          // booking history details text
          bodyMedium: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFFEDF2FF)),

          // validator texts
          bodySmall: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: Color(0xFFEDF2FF)),

          // submit and update button
          labelLarge: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFFEDF2FF)),

          // appbar
          titleLarge: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 23,
              fontWeight: FontWeight.normal,
              color: Color(0xFFEDF2FF)),

          // placeholder text in textfields, checkbox tiles, dropdown options
          titleMedium: TextStyle(
              fontFamily: 'ProductSans',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFFEDF2FF)),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CustomPageTransitionBuilder(),
            TargetPlatform.iOS: CustomPageTransitionBuilder(),
          },
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: const MaterialColor(
            0xFF0A0F2C,
            <int, Color>{
              50: Color(0xFF0A0F2C),
              100: Color(0xFF0A0F2C),
              200: Color(0xFF0A0F2C),
              300: Color(0xFF0A0F2C),
              400: Color(0xFF0A0F2C),
              500: Color(0xFF0A0F2C),
              600: Color(0xFF0A0F2C),
              700: Color(0xFF0A0F2C),
              800: Color(0xFF0A0F2C),
              900: Color(0xFF0A0F2C),
            },
          ),
        )
            .copyWith(
              primary: const Color(0xFF0A0F2C),
              secondary: const Color(0xFF0A0F2C),
            )
            .copyWith(error: const Color(0xFFFF6262)),
      ),
      home: const Login(
        usernamePlaceholder: '',
        passwordPlaceholder: '',
      ),
    );
  }
}
