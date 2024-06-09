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
                  'Any supplements and dietary changes should be discussed with your doctor first to ensure the best outcomes for you and your baby.',
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
              content(
                viewFolicAcid,
                'Prevents neural tube defects',
                'Leafy green vegetables (spinach, kale), citrus fruits (oranges, grapefruits), beans, lentils, fortified cereals, and bread.',
                '600 micrograms',
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
                'Red meat, poultry, fish, lentils, beans, spinach, fortified cereals, and quinoa.',
                '27 milligrams',
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
              content(
                viewCalcium,
                'Builds baby\'s bones and teeth',
                'Dairy products (milk, cheese, yogurt), fortified plant-based milks (almond, soy), leafy green vegetables (broccoli, kale), tofu, and almonds.',
                '1000 milligrams',
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
                'Fatty fish (salmon, mackerel, sardines), fortified dairy and plant-based milks, fortified cereals, and exposure to sunlight.',
                '600 IU (15 micrograms)',
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
              content(
                viewOmega3,
                'Supports brain and eye development',
                'Fatty fish (salmon, mackerel, sardines), flaxseeds, chia seeds, walnuts, and omega-3 fortified eggs.',
                '200-300 milligrams',
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
                'Lean meats (chicken, turkey), fish, eggs, dairy products, beans, lentils, nuts, and seeds.',
                '71 grams',
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
                'Iodized salt, seafood, dairy products, eggs, and seaweed.',
                '220 micrograms',
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
                'Poultry, fish, potatoes, bananas, chickpeas, and fortified cereals.',
                '1.9 milligrams',
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
                'Meat, poultry, fish, eggs, dairy products, and fortified cereals.',
                '2.6 micrograms',
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
                'Citrus fruits (oranges, lemons), strawberries, bell peppers, broccoli, Brussels sprouts, and tomatoes.',
                '85 milligrams',
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
                'Nuts (almonds, cashews), seeds (pumpkin, chia), whole grains, leafy green vegetables (spinach), and legumes.',
                '350-400 milligrams',
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
              content(
                viewZinc,
                'Supports immune function and cell division',
                'Meat, shellfish, legumes (chickpeas, lentils), seeds (pumpkin, sesame), nuts, dairy products, and whole grains.',
                '11 milligrams',
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
                'Whole grains, fruits (apples, pears), vegetables (carrots, broccoli), legumes (beans, lentils), nuts, and seeds.',
                '28 grams',
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget content(bool view, String benefits, String sources, String recdaily) =>
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
                          Expanded(
                            child: Text('Sources:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF9CB4F0),
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
                            child: Text(sources,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                  color: Color(0xFF9CB4F0),
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
