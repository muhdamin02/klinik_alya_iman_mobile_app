// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class ScreeningsTests extends StatefulWidget {
  const ScreeningsTests({
    Key? key,
  }) : super(key: key);

  @override
  _ScreeningsTestsState createState() => _ScreeningsTestsState();
}

class _ScreeningsTestsState extends State<ScreeningsTests>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
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
        title: const Text('Screenings and Tests'),
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
                    'What Is Recommended',
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
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/blood_test.jpg',
                    title: 'Blood Tests',
                    purpose:
                        'Blood tests are essential for checking your overall health, screening for infections, determining your blood type and Rh factor, and assessing your risk for genetic conditions. During the test, a sample of your blood will be taken from your arm. These tests help identify potential issues early, such as anemia, infections, and blood incompatibility, ensuring timely management and care.',
                    tests:
                        'Complete Blood Count (CBC), Blood Type and Rh Factor, Infection Screening, Glucose Test, Thyroid Function Tests'),
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/ultrasound.jpg',
                    title: 'Ultrasound',
                    purpose:
                        'Ultrasounds confirm the pregnancy, check for the baby\'s heartbeat, estimate the due date, and assess the risk of chromosomal conditions. A transabdominal ultrasound uses a gel and a handheld device on your abdomen to create images of your baby. Early ultrasounds confirm the pregnancy and its location, while the nuchal translucency ultrasound can detect the risk of Down syndrome and other abnormalities.',
                    tests: 'Dating Ultrasound, Nuchal Translucency Ultrasound'),
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/genetic_screening.jpg',
                    title: 'Genetic Screenings',
                    purpose:
                        'Genetic screenings evaluate the risk of your baby having certain genetic disorders, such as Down syndrome, trisomy 18, and trisomy 13. A blood sample will be taken from your arm for tests like Non-Invasive Prenatal Testing (NIPT). These screenings provide early information about the baby\'s risk for specific genetic conditions, allowing for informed decision-making and preparation.',
                    tests:
                        'Non-Invasive Prenatal Testing (NIPT), Carrier Screening'),
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/urine_test.jpg',
                    title: 'Urine Tests',
                    purpose:
                        'Urine tests check for urinary tract infections and monitor protein and glucose levels. You will provide a urine sample for these tests. Detecting infections and monitoring glucose levels helps prevent complications such as preeclampsia and gestational diabetes.',
                    tests: 'Urinalysis, Urine Culture'),
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/pap_smear.jpg',
                    title: 'Pap Smear and Cervical Screening',
                    purpose:
                        'Pap smears and cervical screenings are conducted to screen for cervical cancer and infections. During the procedure, a speculum is used to open the vagina, and a small brush is used to collect cells from the cervix. Early detection of abnormal cells and infections ensures prompt treatment, protecting both mother and baby.',
                    tests: 'Pap Smear, HPV Test'),
                ContentScreeningsTests(
                    imagePath: 'assets/screenings_tests/combined_screening.jpg',
                    title: 'Combined Screening Tests',
                    purpose:
                        'Combined screening tests use blood tests and ultrasound measurements to assess the risk of chromosomal abnormalities. A blood sample is taken, and an ultrasound is performed between 11 and 14 weeks. These tests provide a complete risk assessment for conditions like Down syndrome, aiding in early diagnosis and intervention.',
                    tests: 'First Trimester Combined Screening'),
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

class ContentScreeningsTests extends StatelessWidget {
  final String imagePath;
  final String title;
  final String purpose;
  final String tests;

  const ContentScreeningsTests(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.purpose,
      required this.tests});

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
              height: 150,
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
                  fontSize: 24,
                  color: Color(0xFFEDF2FF),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            Text(
              purpose,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Includes:',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF9CB4F0),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            Text(
              tests,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF9CB4F0),
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
