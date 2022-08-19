import 'package:flutter/material.dart';
import 'package:life_track/tutorial/tutorial_model.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

import '../Contants/appcolors.dart';
import '../Contants/constant.dart';
import '../activitytags/add_activity_tag.dart';
import '../components/background_gradient_container.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  final PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  final _currentPageNotifier = ValueNotifier<int>(0);
  int currentPage = 0;

  final List<TutorialModel> _lstTutorial = [
    TutorialModel(
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Bibendum est ultricies integer quis. Iaculis urna id volutpat lacus laoreet. Mauris vitae ultricies leo integer malesuada. Ac odio'),
    TutorialModel('Second screen'),
    TutorialModel('Third screen')
  ];
  void _moveToScreen(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddActivity(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BackgroundGradientContainer(
        child: SafeArea(
          minimum: const EdgeInsets.only(top: 16),
          child: Stack(
            children: [
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Container(
                width: deviceWidth,
                margin: const EdgeInsets.only(top: 60),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          const Text(
                            'Hi Aaron!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 41,
                              fontFamily: fontFamilyName,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Image.asset(
                            'assets/images/splash_logo.png',
                            width: 335,
                            height: 105,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    CirclePageIndicator(
                      dotColor: const Color(0xFFffffff).withOpacity(0.3),
                      selectedDotColor: const Color(0xFF35c957),
                      size: 18,
                      selectedSize: 18,
                      itemCount: _lstTutorial.length,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 250,
                          width: deviceWidth,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.PRIMARY_COLOR,
//Color(0xFF055633),
                                Colors.black,
                              ],
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20),
                            ),
                          ),
                          child: null,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 150,
                              width: deviceWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: PageView.builder(
                                  itemCount: _lstTutorial.length,
                                  controller: _pageController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  onPageChanged: (int index) {
                                    _currentPageNotifier.value = index;
                                  },
                                  itemBuilder: (context, index) {
                                    return Text(
                                      _lstTutorial[index].title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: fontFamilyName,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 80,
                              width: deviceWidth,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) => AppColors
                                                .SUBMIT_BUTTON_BACKGROUND),
                                    minimumSize:
                                        MaterialStateProperty.resolveWith(
                                      (states) => const Size.fromHeight(50),
                                    ),
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (currentPage ==
                                        _lstTutorial.length - 1) {
                                      _moveToScreen(context);
                                      return;
                                    }
                                    print(_currentPageNotifier.value);
                                    setState(() {
                                      currentPage = currentPage + 1;
                                    });
                                    _pageController.animateToPage(
                                        ((_pageController.page ?? 0.0) + 1.0)
                                            .toInt(),
                                        duration:
                                            const Duration(microseconds: 200),
                                        curve: Curves.bounceIn);
                                  },
                                  child: Text(
                                    currentPage < _lstTutorial.length - 1
                                        ? 'Next'
                                        : 'Start Setup',
                                    style: const TextStyle(
                                      fontFamily: fontFamilyName,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
