import 'package:flutter/material.dart';
import 'package:taxify_driver/shared/constants/constants.dart';
import 'package:taxify_driver/shared/utils/utils.dart';

final List<Map> onboardingPages = [
  {
    "title": "Drive on Your Terms!",
    "subtitle": "Set your availability and start earning with every ride.",
    "image": "onboarding_1.png",
  },

  {
    "title": "Rides Made Easy!",
    "subtitle":
        "Accept ride requests and navigate seamlessly to your passenger.",
    "image": "onboarding_2.png",
  },

  {
    "title": "Track Your Earnings!",
    "subtitle":
        "Get real-time fare updates and insights on your daily earnings.",
    "image": "onboarding_3.png",
  },
];

class OnboardingPageScroll extends StatefulWidget {
  const OnboardingPageScroll({super.key});

  @override
  State<OnboardingPageScroll> createState() => _OnboardingPageScrollState();
}

class _OnboardingPageScrollState extends State<OnboardingPageScroll> {
  late int currentPage;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: pageController,
              onPageChanged: (page) => setState(() => currentPage = page),
              children:
                  onboardingPages
                      .map(
                        (page) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              page["title"],
                              style: getTextTheme(context).headlineLarge,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            Image.asset(
                              "assets/images/${page["image"]}",
                              height: 250,
                            ),
                            SizedBox(height: 20),
                            Text(
                              page["subtitle"],
                              style: getTextTheme(context).bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                      .toList(),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                for (int i = 0; i < 3; i++) ...[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentPage = i;
                        });

                        pageController.animateToPage(
                          i,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.linear,
                        );
                      },
                      child: Container(
                        height: 4,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                          color:
                              i == currentPage
                                  ? AppColors.accent
                                  : AppColors.lightGray,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
