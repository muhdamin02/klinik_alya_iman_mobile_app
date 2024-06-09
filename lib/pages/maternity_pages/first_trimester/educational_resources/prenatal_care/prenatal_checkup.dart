// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class PrenatalCheckup extends StatefulWidget {
  const PrenatalCheckup({
    Key? key,
  }) : super(key: key);

  @override
  _PrenatalCheckupState createState() => _PrenatalCheckupState();
}

class _PrenatalCheckupState extends State<PrenatalCheckup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prenatal Check-ups'),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDF2FF),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'Why Check-Ups Matter',
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFFFD271),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'Regular prenatal check-ups are vital for ensuring the health and well-being of both you and your baby. These visits allow your healthcare provider to monitor your pregnancy progress and address any concerns.',
                style: TextStyle(
                  fontSize: 18,
                  height: 2,
                  color: Color(0xFFC5D6FF),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 36.0),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Text(
                'What Check-ups Do',
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFEDF2FF),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 5.0,
                    decoration: BoxDecoration(
                      color: const Color(0xFF303E8F),
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the radius as needed
                    ),
                    margin: const EdgeInsets.only(right: 24),
                    child: Column(
                      children: List.generate(
                          58,
                          (index) => Container(
                              height:
                                  10)), // Adjust this as needed to ensure the line covers the full height of your content
                    ),
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Monitor Baby\'s Growth',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Track your baby\'s growth and development.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.0),
                        Text(
                          'Health Assessments',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Early detection and management of health issues.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.0),
                        Text(
                          'Nutritional Guidance',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Get personalized advice on supplements and diet.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.0),
                        Text(
                          'Vaccinations',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Stay protected with recommended vaccines.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.0),
                        Text(
                          'Emotional Support',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Discuss any emotional concerns with your provider.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 28.0),
                        Text(
                          'Birth Planning',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFEDF2FF),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Prepare for labor and delivery with your healthcare provider.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.6,
                            color: Color(0xFFC5D6FF),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Monitor Baby\'s Growth',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Track your baby\'s growth and development.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 28.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Health Assessments',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Early detection and management of health issues.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 28.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Nutritional Guidance',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Get personalized advice on supplements and diet.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 28.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Vaccinations',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Stay protected with recommended vaccines.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 28.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Emotional Support',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Discuss any emotional concerns with your provider.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 28.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Birth Planning',
            //     style: TextStyle(
            //         fontSize: 18,
            //         color: Color(0xFFEDF2FF),
            //         fontWeight: FontWeight.w600,
            //         letterSpacing: 1.5),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            // SizedBox(height: 8.0),
            // Padding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 24,
            //   ),
            //   child: Text(
            //     'Prepare for labor and delivery with your healthcare provider.',
            //     style: TextStyle(
            //       fontSize: 16,
            //       height: 1.6,
            //       color: Color(0xFFC5D6FF),
            //       fontWeight: FontWeight.w500,
            //     ),
            //     textAlign: TextAlign.left,
            //   ),
            // ),
            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
