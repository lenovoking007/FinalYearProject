import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travelmate/loginpage.dart';
import 'package:travelmate/model/onboardingmodel.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  _OnboardState createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isInitialized = false;
  bool _showOnboarding = true;

  final List<OnBoardingModel> _onboardingPages = [
    OnBoardingModel(
      image: 'assets/images/p1.jpg',
      title: 'Explore the World with Ease',
      description: 'Discover hidden gems and plan your perfect trip with our comprehensive travel tools',
    ),
    OnBoardingModel(
      image: 'assets/images/p2.jpg',
      title: 'Reach Unique Destinations',
      description: 'Get personalized recommendations for destinations you\'ll love',
    ),
    OnBoardingModel(
      image: 'assets/images/p3.jpg',
      title: 'Connect with Travel Community',
      description: 'Share experiences and get tips from fellow travelers',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (!isFirstLaunch) {
      if (mounted) {
        setState(() {
          _showOnboarding = false;
        });
      }
      _navigateToLogin();
    } else {
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_launch', false);
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const loginn(),
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0XFF0066CC),
          ),
        ),
      );
    }

    if (!_showOnboarding) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0XFF0066CC),
          ),
        ),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content Column
            Column(
              children: [
                // Top Spacer (for skip button)
                SizedBox(height: screenHeight * 0.05),

                // Page View Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingPages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image with proper margin
                            Container(
                              margin: EdgeInsets.only(bottom: screenHeight * 0.04),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  _onboardingPages[index].image,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                            // Title
                            Container(
                              margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                              child: Text(
                                _onboardingPages[index].title,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.065,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0XFF0066CC),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Description
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              child: Text(
                                _onboardingPages[index].description,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.042,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Page Indicator
                Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.04),
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingPages.length,
                    effect: const WormEffect(
                      activeDotColor: Color(0XFF0066CC),
                      dotColor: Color(0XFF77B7F7),
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 8,
                    ),
                  ),
                ),

                // Next/Get Started Button
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.05,
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _onboardingPages.length - 1) {
                        _completeOnboarding();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF0066CC),
                      minimumSize: Size(double.infinity, screenHeight * 0.065),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                    child: Text(
                      _currentPage == _onboardingPages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Skip Button (positioned absolutely)
            Positioned(
              top: screenHeight * 0.02,
              right: screenWidth * 0.05,
              child: TextButton(
                onPressed: _completeOnboarding,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                ),
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: const Color(0XFF0066CC),
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}