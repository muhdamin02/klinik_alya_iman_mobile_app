// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';

class Bathing extends StatefulWidget {
  const Bathing({
    Key? key,
  }) : super(key: key);

  @override
  _BathingState createState() => _BathingState();
}

class _BathingState extends State<Bathing> with SingleTickerProviderStateMixin {
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
        title: const Text('Basic Care Information'),
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
                    'Bathing',
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
                BathingContent(),
                BathingContent2(),
                BathingContent3(),
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

class BathingContent extends StatelessWidget {
  const BathingContent({super.key});

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
                      image: AssetImage('assets/diapering/change.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'How to Bathe a Newborn',
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
              'Sponge Baths',
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
              'For the first few weeks, clean the baby with a sponge bath using warm water and a gentle, mild soap.',
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
              'Tub Baths',
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
              'Once the umbilical cord has healed, you can give the baby a tub bath. Fill the tub with a few inches of warm water, hold the baby securely, and gently wash with a mild baby soap.',
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

class BathingContent2 extends StatelessWidget {
  const BathingContent2({super.key});

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
                      image: AssetImage('assets/diapering/type.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Frequency',
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
              'Newborns',
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
              'Bathing 2-3 times a week is usually sufficient. Too much bathing can dry out the baby\'s skin.',
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

class BathingContent3 extends StatelessWidget {
  const BathingContent3({super.key});

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
                      image: AssetImage('assets/diapering/rash.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Best Products',
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
              'Soap and Shampoo',
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
              'Use mild, fragrance-free baby soaps and shampoos.',
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
              'Bathing Accessories',
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
              'Soft washcloths, a baby bathtub, and hooded towels for drying.',
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
