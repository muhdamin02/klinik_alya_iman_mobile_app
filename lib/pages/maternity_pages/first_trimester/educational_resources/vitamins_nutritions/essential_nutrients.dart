// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class EssentialNutrients extends StatefulWidget {
  const EssentialNutrients({
    Key? key,
  }) : super(key: key);

  @override
  _EssentialNutrientsState createState() => _EssentialNutrientsState();
}

class _EssentialNutrientsState extends State<EssentialNutrients> {
  bool viewFolicAcid = false;
  bool viewIron = false;
  bool viewCalcium = false;
  bool viewFiber = false;
  bool viewIodine = false;
  bool viewMagnesium = false;
  bool viewOmega3 = false;
  bool viewProtein = false;
  bool viewVitaminB12 = false;
  bool viewVitaminB6 = false;
  bool viewVitaminC = false;
  bool viewVitaminD = false;
  bool viewZinc = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Essential Nutrients'),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDF2FF),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8.0),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        viewFolicAcid = !viewFolicAcid;
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
                            "Folic Acid (Folate)",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewFolicAcid)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewFolicAcid)
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
              content(viewFolicAcid, 'Prevents neural tube defects',
                  '600 micrograms'),
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
                        viewIron = !viewIron;
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
                            "Iron",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewIron)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewIron)
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
                  viewIron,
                  'Supports increased blood volume and prevents anemia',
                  '27 milligrams'),
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
                        viewCalcium = !viewCalcium;
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
                            "Calcium",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewCalcium)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewCalcium)
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
              content(viewCalcium, 'Builds baby\'s bones and teeth',
                  '1000 milligrams'),
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
                        viewVitaminD = !viewVitaminD;
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
                            "Vitamin D",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewVitaminD)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewVitaminD)
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
                  viewVitaminD,
                  'Aids in calcium absorption and supports bone health',
                  '600 IU (15 micrograms)'),
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
                        viewOmega3 = !viewOmega3;
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
                            "Omega-3 Fatty Acids",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewOmega3)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewOmega3)
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
              content(viewOmega3, 'Supports brain and eye development',
                  '200-300 milligrams'),
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
                        viewProtein = !viewProtein;
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
                            "Protein",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewProtein)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewProtein)
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
                  viewProtein,
                  'Supports growth and development of fetal tissues',
                  '71 grams'),
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
                        viewIodine = !viewIodine;
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
                            "Iodine",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewIodine)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewIodine)
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
                  viewIodine,
                  'Supports thyroid function and brain development',
                  '220 micrograms'),
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
                        viewVitaminB6 = !viewVitaminB6;
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
                            "Vitamin B6",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewVitaminB6)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewVitaminB6)
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
                  viewVitaminB6,
                  'Helps with the development of the baby\'s brain and nervous system',
                  '1.9 milligrams'),
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
                        viewVitaminB12 = !viewVitaminB12;
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
                            "Vitamin B12",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewVitaminB12)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewVitaminB12)
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
                  viewVitaminB12,
                  'Supports nerve and blood cell health, and helps make DNA',
                  '2.6 micrograms'),
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
                        viewVitaminC = !viewVitaminC;
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
                            "Vitamin C",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewVitaminC)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewVitaminC)
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
                  viewVitaminC,
                  'Promotes healthy skin, bones, and connective tissue; helps in iron absorption',
                  '85 milligrams'),
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
                        viewMagnesium = !viewMagnesium;
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
                            "Magnesium",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewMagnesium)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewMagnesium)
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
                  viewMagnesium,
                  'Supports bone health and energy production',
                  '350-400 milligrams'),
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
                        viewZinc = !viewZinc;
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
                            "Zinc",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewZinc)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewZinc)
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
              content(viewZinc, 'Supports immune function and cell division',
                  '11 milligrams'),
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
                        viewFiber = !viewFiber;
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
                            "Fiber",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          if (!viewFiber)
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Color(
                                  0xFFB6CBFF), // Set the color of the icon
                              size: 20, // Adjust the size of the icon as needed
                            ),
                          if (viewFiber)
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
                  viewFiber,
                  'Helps prevent constipation, a common issue during pregnancy',
                  '28 grams'),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget content(bool view, String benefits, String recdaily) =>
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
                            child: Text(benefits,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
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
                          Text(
                            'Recommended daily intake:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFEDF2FF),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            recdaily,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Color(0xFFFFE2A2),
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const Spacer(),
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
