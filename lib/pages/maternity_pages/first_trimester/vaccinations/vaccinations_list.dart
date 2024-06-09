// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class VaccinationsList extends StatefulWidget {
  const VaccinationsList({
    Key? key,
  }) : super(key: key);

  @override
  _VaccinationsListState createState() => _VaccinationsListState();
}

class _VaccinationsListState extends State<VaccinationsList> {
  bool view1 = false;
  bool view2 = false;
  bool view3 = false;
  bool view4 = false;
  bool view5 = false;
  bool view6 = false;
  bool view7 = false;
  bool view8 = false;
  bool view9 = false;
  bool view10 = false;
  bool view11 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List of Vaccines'),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDF2FF),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        'Disclaimer',
                        style: TextStyle(
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 2,
                            fontSize: 16),
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
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                ),
                child: Text(
                  'Always consult with your healthcare provider before getting vaccinated to ensure the timing and type of vaccine are safe and appropriate for your specific situation. They can provide personalized recommendations based on your health history and potential risks.',
                  style: TextStyle(
                      fontSize: 16, height: 2, color: Color(0xFFC5D6FF)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 56.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        'Recommended Vaccines',
                        style: TextStyle(
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 2,
                            fontSize: 16),
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
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view1 = !view1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Influenza (Flu) Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view1)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view1)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                view1,
                'Protects against the seasonal flu, which can cause severe illness in pregnant women and complications for the baby.',
                'Any time during pregnancy, preferably before the flu season starts.',
                'Inactivated (injectable) flu vaccine is recommended.',
              ),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view2 = !view2;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Tdap Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view2)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view2)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                view2,
                'Protects against whooping cough (pertussis), which can be severe for newborns. Provides passive immunity to the baby.',
                'During the third trimester (between 27 and 36 weeks of pregnancy) for each pregnancy.',
                'Tdap (Tetanus, Diphtheria, and Pertussis) vaccine.',
              ),
              //-----------------------------------//
              const SizedBox(height: 56),
              //-----------------------------------//
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        'Special Considerations',
                        style: TextStyle(
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 2,
                            fontSize: 16),
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
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view3 = !view3;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Hepatitis B Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view3)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view3)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                  view3,
                  'Protects against hepatitis B, which can be transmitted to the baby during birth.',
                  'If you are at high risk for hepatitis B infection, your healthcare provider may recommend this vaccine during pregnancy.',
                  'Recombinant vaccine (e.g., Engerix-B, Recombivax HB).'),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view4 = !view4;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "COVID-19 Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view4)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view4)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                  view4,
                  'Protects against severe illness from COVID-19.',
                  'Recommended during pregnancy to protect both mother and baby.',
                  'mRNA vaccines (e.g., Pfizer-BioNTech, Moderna) or vector vaccines (e.g., Johnson & Johnson\'s Janssen).'),
              //-----------------------------------//
              const SizedBox(height: 56),
              //-----------------------------------//
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        'Vaccines to Avoid',
                        style: TextStyle(
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 2,
                            fontSize: 16),
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
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view5 = !view5;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "MMR Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view5)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view5)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              contentAvoid(
                  view5,
                  'MMR (Measles, Mumps, Rubella) vaccine is a live vaccine that could potentially harm the developing fetus.',
                  'Should be administered at least one month before becoming pregnant or postpartum.'),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view6 = !view6;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Varicella Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view6)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view6)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              contentAvoid(
                  view6,
                  'Varicella (Chickenpox) vaccine is a live vaccine that could potentially harm the developing fetus.',
                  'Should be administered at least one month before becoming pregnant or postpartum.'),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view7 = !view7;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "HPV Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view7)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view7)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              contentAvoid(
                view7,
                'HPV (Human Papillomavirus) vaccine is not recommended during pregnancy due to lack of sufficient safety data.',
                'Should be administered before pregnancy or postponed until after delivery.',
              ),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view8 = !view8;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Zoster Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view8)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view8)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              contentAvoid(
                  view8,
                  'Zoster (Shingles) vaccine is a live vaccine that could potentially harm the developing fetus.',
                  'Should be administered before pregnancy or postponed until after delivery.'),
              //-----------------------------------//
              const SizedBox(height: 56),
              //-----------------------------------//
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
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
                        'Consider Before Pregnancy',
                        style: TextStyle(
                            color: Color(0xFFEDF2FF),
                            letterSpacing: 2,
                            fontSize: 16),
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
              const SizedBox(height: 32.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view9 = !view9;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Hepatitis A Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view9)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view9)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                  view9,
                  'Protects against hepatitis A, a liver infection that can cause serious health issues during pregnancy.',
                  'Should be administered before pregnancy if you are at risk.',
                  'Inactivated vaccine.'),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view10 = !view10;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Pneumococcal Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view10)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view10)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                  view10,
                  'Recommended for women with certain high-risk conditions, such as chronic heart or lung disease, diabetes, or immunocompromising conditions.',
                  'Should be administered before pregnancy if you are at risk.',
                  'Polysaccharide or conjugate vaccine.'),
              //-----------------------------------//
              const SizedBox(height: 16),
              //-----------------------------------//
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        view11 = !view11;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      backgroundColor: const Color(0xFF222E75),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        children: [
                          const Text(
                            "Meningococcal Vaccine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view11)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view11)
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              content(
                  view11,
                  'May be recommended if you are at increased risk for meningococcal disease due to certain medical conditions or other factors.',
                  'Should be administered before pregnancy if you are at risk.',
                  'Conjugate or polysaccharide vaccine.'),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget content(bool view, String explanation, String whenTake, String type) =>
      AnimatedOpacity(
        opacity: view ? 1.0 : 0.0,
        duration:
            const Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeInOut, // Adjust the curve as needed
        child: Visibility(
          visible: view,
          child: SizedBox(
            width: double.infinity, // Ensures the button takes full width
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color(0xFF303E8F),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 28.0, left: 18, right: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(explanation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color(0xFFB6CBFF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: Text('When to Take:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(whenTake,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: Text('Type:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(type,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget contentAvoid(bool view, String explanation, String whenTake) =>
      AnimatedOpacity(
        opacity: view ? 1.0 : 0.0,
        duration:
            const Duration(milliseconds: 300), // Adjust the duration as needed
        curve: Curves.easeInOut, // Adjust the curve as needed
        child: Visibility(
          visible: view,
          child: SizedBox(
            width: double.infinity, // Ensures the button takes full width
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  backgroundColor: const Color(0xFF303E8F),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 20.0, bottom: 28.0, left: 18, right: 18),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(explanation,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Color(0xFFB6CBFF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        children: [
                          Expanded(
                            child: Text('When to Take:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(whenTake,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Color(0xFFC5D6FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
