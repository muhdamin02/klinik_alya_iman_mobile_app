// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MentalHealthResources extends StatefulWidget {
  const MentalHealthResources({
    Key? key,
  }) : super(key: key);

  @override
  _MentalHealthResourcesState createState() => _MentalHealthResourcesState();
}

class _MentalHealthResourcesState extends State<MentalHealthResources> {
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

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mental Health Resources'),
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
                        'Help is Available',
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
                  'If you\'re feeling overwhelmed or anxious, know that there is support out there for you. Reaching out for help is a brave and important step. You are not alone, and there is help every step of the way.',
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
                            "National Population and\nFamily Development Board",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
                'assets/mental_health_resources/lppkn.png',
                'National Population and Family Development Board (LPPKN) provides counseling and support for expectant and new mothers and developing families, including mental health support.',
                'https://www.lppkn.gov.my/lppkngateway/frontend/web/',
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
                            "Malaysian Mental Health\nAssociation",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
                'imagepath',
                'The Malaysian Mental Health Association (MMHA) is a non-profit Non-Government Organisation registered under the Societies Act 1966 MMHA is managed by an elected committee of interested persons and professionals in the community, including caregivers of persons living with mental disorders.',
                'https://www.mmha.org.my/',
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
                            "Relate Malaysia",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
                  'imagepath',
                  'Relate Mental Health Malaysia is an organization established to increase mental health literacy and awareness, promote prevention and early intervention, and encourage the establishment of community support and services for all who need them.',
                  'https://relate.com.my/'),
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
                            "Women\'s Aid Organisation",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
                  'imagepath',
                  'Women\'s Aid Organisation (WAO) offers support services for women, including counseling and shelter. They address mental health issues related to domestic violence and other challenges.',
                  'https://wao.org.my/'),
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
                            "National Centre of Excellence\nfor Mental Health",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
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
                  'imagepath',
                  'The National Centre of Excellence for Mental Health (NCEMH) is part of the plan to strengthen mental health programs, requiring a comprehensive and thorough platform to provide input and direction for national mental health program policies and guidelines.',
                  'https://sites.google.com/moh.gov.my/ncemh'),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  Widget content(bool view, String imagePath, String description, String url) =>
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
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color(0xFFEDF2FF),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Container(
                            margin: const EdgeInsets.all(
                                3.0), // The width of the gradient border
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                image: AssetImage(
                                    imagePath), // Replace with your image path
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Text(description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  color: Color(0xFFEDF2FF),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.left,
                                softWrap: true,
                                overflow: TextOverflow.visible),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _launchURL(url),
                              child: Text("Click here",
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
