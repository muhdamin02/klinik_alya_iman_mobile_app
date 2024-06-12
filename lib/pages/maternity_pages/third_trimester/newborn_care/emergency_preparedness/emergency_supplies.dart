// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class EmergencySupplies extends StatefulWidget {
  const EmergencySupplies({
    Key? key,
  }) : super(key: key);

  @override
  _EmergencySuppliesState createState() => _EmergencySuppliesState();
}

class _EmergencySuppliesState extends State<EmergencySupplies>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Emergency Preparedness'),
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
                    'Emergency Supplies',
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
                Content(),
                Content2(),
                Content3(),
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
  const Content({super.key});

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
                    image: const DecorationImage(
                      image: AssetImage('assets/supplies/first.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'First Aid Kit',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFE2A2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'Contents',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Include items like bandages, gauze, adhesive tape, antiseptic wipes, a digital thermometer, tweezers, infant pain reliever, and saline nose drops.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Storage',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Keep the kit in an easily accessible location and ensure all caregivers know where it is.',
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
    );
  }
}

class Content2 extends StatelessWidget {
  const Content2({super.key});

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
                    image: const DecorationImage(
                      image: AssetImage('assets/supplies/emergency.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Emergency Numbers',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFE2A2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'Accessibility',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Post emergency numbers (including those in your contact list) near phones and in prominent locations around the house.',
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
    );
  }
}

class Content3 extends StatelessWidget {
  const Content3({super.key});

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
                    image: const DecorationImage(
                      image: AssetImage('assets/supplies/other.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Other Supplies',
              style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFE2A2),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  height: 1.5),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 18.0),
            const Text(
              'Extra Diapers and Wipes',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Have a sufficient supply of diapers and wipes.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Formula and Bottles',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Keep an extra supply of formula and clean bottles if you are formula feeding.',
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFFC5D6FF),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Blankets and Clothes',
              style: TextStyle(
                fontSize: 18,
                height: 1.6,
                color: Color(0xFFEDF2FF),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Store extra blankets and weather-appropriate clothing for your baby.',
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
    );
  }
}
