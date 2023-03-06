import 'package:flutter/material.dart';

import '../../../models/splash_item.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/string_manager.dart';
import '../../utils/background_container.dart';
import '../../widgets/splash_component.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController pageController = PageController(initialPage: 0);

  final List<SplashItem> splashItems = [
    SplashItem(
      id: 1,
      title: AppString.splashTitle1,
      showImage: false,
    ),
    SplashItem(
      id: 2,
      title: AppString.splashTitle2,
      imgUrl: AssetManager.splashImage1,
    ),
    SplashItem(
      id: 3,
      title: AppString.splashTitle3,
      imgUrl: AssetManager.splashImage2,
    ),
  ];

  void setNewPage(int page) {
    setState(() {
      pageController.animateToPage(
        page,
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    });

    print('Hello');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundContainer(
        begin: Alignment.topCenter,
        stops: const [0.1, 1.0],
        child: Center(
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              setState(() {});
            },
            itemCount: splashItems.length,
            itemBuilder: (context, index) => SplashComponent(
              splashItem: splashItems[index],
              splashLength: splashItems.length,
              pageController: pageController,
              setNewPage: setNewPage,
            ),
          ),
        ),
      ),
    );
  }
}
