import 'package:flutter/material.dart';
import 'package:travelmate/model/onboardingmodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'loginpage.dart';
import 'dart:io'; // For app exit functionality

class onboard extends StatefulWidget {
  onboard({super.key});

  @override
  _onboardState createState() => _onboardState();
}

class _onboardState extends State<onboard> {
  List<OnBoardingModel> listonboard = [
    OnBoardingModel(
        image: 'assets/images/p1.jpg',
        title: 'Explore the World with Ease',
        description: 'Find Every Hidden Gem'),
    OnBoardingModel(
        image: 'assets/images/p2.jpg',
        title: 'Reach Unique Destinations',
        description: 'Your Journey Awaits'),
    OnBoardingModel(
        image: 'assets/images/p3.jpg',
        title: 'Connect with Travel Mate',
        description: 'For Memories that Last')
  ];

  PageController controller = PageController();
  int previousPageIndex = 0; // Track previous page index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double screenWidth = constraints.maxWidth;

          return Container(
            color: Colors.white,
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: controller,
                      itemCount: listonboard.length,
                      scrollDirection: Axis.horizontal,
                      onPageChanged: (index) {
                        // Only trigger when swiping forward to last page
                        if (index == listonboard.length - 1 &&
                            previousPageIndex == listonboard.length - 2) {
                          // Delay the navigation to make sure the user swiped
                          Future.delayed(Duration(milliseconds: 300), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => loginn()),
                            );
                          });
                        }
                        previousPageIndex = index; // Update previous page index
                      },
                      itemBuilder: (context, i) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                listonboard[i].image.toString(),
                                height: screenHeight * 0.3,
                                width: screenWidth * 0.6,
                              ),
                              SizedBox(height: screenHeight * 0.03),
                              Text(
                                listonboard[i].title.toString(),
                                style: TextStyle(
                                    fontSize: screenHeight * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF0066CC)),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.1),
                                child: Text(
                                  listonboard[i].description.toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: screenHeight * 0.02,
                                      color: Color(0XFF0066CC) ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: controller,
                    count: listonboard.length,
                    effect: JumpingDotEffect(
                      activeDotColor: Color(0XFF0066CC),
                      dotColor: Color(0XFF77B7F7),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
