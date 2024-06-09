// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class HealthyDiet extends StatefulWidget {
  const HealthyDiet({
    Key? key,
  }) : super(key: key);

  @override
  _HealthyDietState createState() => _HealthyDietState();
}

class _HealthyDietState extends State<HealthyDiet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Diet'),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xFFEDF2FF),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
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
              horizontal: 24,
            ),
            child: Text(
              'Any supplements and dietary changes should be discussed with your doctor first to ensure the best outcomes for you and your baby.',
              style:
                  TextStyle(fontSize: 16, height: 2, color: Color(0xFFC5D6FF)),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            child: const Divider(
              color: Color(0xFFB6CBFF),
              height: 1,
            ),
          ),
          const SizedBox(height: 32.0),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'Overview',
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFFFFD271),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12.0),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Text(
              'Maintaining a healthy diet during pregnancy is crucial for both you and your baby.',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Balanced Meals',
                    description:
                        'Incorporate a variety of foods from all food groups: fruits, vegetables, whole grains, lean proteins, and dairy or dairy alternatives.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Nutrient-Rich Foods',
                    description:
                        'Focus on nutrient-dense foods that provide essential vitamins and minerals. Examples include leafy greens, berries, nuts, seeds, lean meats, and whole grains.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Hydration',
                    description:
                        'Drink plenty of water throughout the day to stay hydrated. Aim for at least 8-10 glasses a day, and more if you\'re physically active or live in a hot climate.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Small, Frequent Meals',
                    description:
                        'Eat smaller, more frequent meals to help manage nausea and maintain steady energy levels. This can also help with digestive comfort as your pregnancy progresses.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Healthy Snacks',
                    description:
                        'Keep healthy snacks on hand, such as yogurt, nuts, fresh fruits, and vegetables, to manage hunger and provide nutritional benefits.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Foods to Avoid',
                    description:
                        'Stay away from foods that can be harmful during pregnancy, such as raw or undercooked meats, unpasteurized dairy products, certain types of fish high in mercury, and raw eggs.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Managing Cravings',
                    description:
                        'Understand that cravings are common but try to balance indulgences with healthy choices. Moderation is key.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Prenatal Vitamins',
                    description:
                        'Complement your diet with prenatal vitamins as recommended by your healthcare provider to ensure you\'re getting all the necessary nutrients.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Cooking Methods',
                    description:
                        'Opt for healthy cooking methods such as grilling, baking, steaming, and sautéing instead of frying.'),
                Content(
                    imagePath: 'assets/educational_resources/vitaminnutrition.jpg',
                    title: 'Mindful Eating',
                    description:
                        'Practice mindful eating by paying attention to hunger and fullness cues, and enjoy your meals without distractions.'),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: TabPageSelector(
                controller: _tabController,
                selectedColor: const Color(0xFFEDF2FF),
                color: const Color(0xFF303E8F),
                indicatorSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Content extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const Content(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                gradient: const LinearGradient(
                  colors: [Color(0xFFB6CBFF), Color(0xFF4D5FC0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                  margin: const EdgeInsets.all(
                      3.0), // The width of the gradient border
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFFEDF2FF),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12.0),
            Text(
              description,
              style: const TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 42),
          ],
        ),
      ),
    );
  }
}
