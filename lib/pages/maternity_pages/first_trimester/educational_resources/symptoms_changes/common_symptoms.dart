// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class CommonSymptoms extends StatefulWidget {
  const CommonSymptoms({
    Key? key,
  }) : super(key: key);

  @override
  _CommonSymptomsState createState() => _CommonSymptomsState();
}

class _CommonSymptomsState extends State<CommonSymptoms> {
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
  bool view12 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Common Symptoms'),
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
                  'Always consult your healthcare practitioner if you experience severe or persistent symptoms, as they can help ensure your health and the health of your baby.',
                  style: TextStyle(
                      fontSize: 16, height: 2, color: Color(0xFFC5D6FF)),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24.0),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                child: const Divider(
                  color: Color(0xFFB6CBFF),
                  height: 1,
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
                            "Nausea and Vomiting",
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
                'Often occurs in the first trimester due to hormonal changes.',
                'Eat small, frequent meals, avoid strong odors, stay hydrated, and consider ginger or vitamin B6 supplements after consulting your doctor.',
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
                            "Fatigue",
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
                'Increased progesterone levels and the body working harder to support the pregnancy can cause tiredness.',
                'Get plenty of rest, take short naps, eat a balanced diet, and stay hydrated.',
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
                            "Heartburn",
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
                'Hormones relax the valve between the stomach and esophagus, causing acid reflux.',
                'Eat smaller meals, avoid spicy and fatty foods, don\'t lie down immediately after eating, and elevate your head while sleeping.',
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
                            "Constipation",
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
                'Progesterone slows down the digestive tract, and iron supplements can contribute to constipation.',
                'Eat high-fiber foods, drink plenty of water, and stay active with gentle exercise.',
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
                            "Frequent Urination",
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
              content(
                view5,
                'The growing uterus puts pressure on the bladder, increasing the need to urinate.',
                'Avoid caffeine, stay hydrated, and empty your bladder completely when you go to the bathroom.',
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
                            "Back Pain",
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
              content(
                view6,
                'Increased weight and changes in posture strain the back muscles.',
                'Practice good posture, wear supportive shoes, use a pregnancy support belt, and do gentle exercises or prenatal yoga.',
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
                            "Breast Tenderness",
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
              content(
                view7,
                'Hormonal changes cause the breasts to prepare for breastfeeding.',
                'Wear a supportive bra, use warm or cold compresses, and avoid unnecessary pressure on the breasts.',
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
                            "Swelling (Edema)",
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
              content(
                view8,
                'Increased blood volume and pressure from the growing uterus can cause swelling in the legs, ankles, and feet.',
                'Elevate your feet, avoid standing for long periods, wear compression stockings, and stay hydrated.',
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
                            "Shortness of Breath",
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
                'The growing uterus can push against the diaphragm, making breathing more difficult.',
                'Maintain good posture, sleep with your head elevated, and do light exercise to improve lung capacity.',
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
                            "Headaches",
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
                'Hormonal changes, stress, and fatigue can lead to headaches.',
                'Rest in a dark room, apply a cold compress to your head, stay hydrated, and practice relaxation techniques.',
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
                            "Dizziness",
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
                'Hormonal changes can cause blood vessels to relax and widen, leading to lower blood pressure.',
                'Stand up slowly, avoid prolonged standing, eat small, frequent meals, and stay hydrated.',
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
                        view12 = !view12;
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
                            "Mood Swings",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!view12)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (view12)
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
                view12,
                'Hormonal fluctuations can affect mood and emotions.',
                'Get plenty of rest, stay physically active, eat well, and seek support from friends, family, or a counselor.',
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget content(bool view, String explanation, String howtoovercome) =>
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
                            child: Text('Potential Ways to Overcome:',
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
                            child: Text(howtoovercome,
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
