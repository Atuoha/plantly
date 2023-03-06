import 'package:flutter/material.dart';
import 'package:plantly/resources/route_manager.dart';
import '../../constants/color.dart';
import '../../models/splash_item.dart';
import '../../resources/assets_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashComponent extends StatelessWidget {
  const SplashComponent(
      {Key? key,
      required this.splashItem,
      required this.splashLength,
      required this.pageController,
      required this.setNewPage})
      : super(key: key);
  final SplashItem splashItem;
  final int splashLength;
  final PageController pageController;
  final Function setNewPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: splashItem.showImage
          ? MainAxisAlignment.start
          : MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (splashItem.showImage) ...[
          Expanded(
            child: Stack(
              children: [
                Image.asset(splashItem.imgUrl),
                Positioned(
                  top: 20,
                  right: 130,
                  child: Image.asset(AssetManager.appNameLogo,
                      width: AppSize.s150),
                ),
                const SizedBox(height: 30),
                Positioned(
                  bottom: 70,
                  left: 30,
                  right: 30,
                  child: splashText(title: splashItem.title),
                )
              ],
            ),
          ),
        ] else ...[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  splashText(title: splashItem.title),
                  const SizedBox(height: 10),
                  Image.asset(AssetManager.appNameLogo, width: AppSize.s150),
                ],
              ),
            ),
          )
        ],
        Center(
          child: SmoothPageIndicator(
            controller: pageController,
            count: splashLength,
            effect: ExpandingDotsEffect(
              activeDotColor: primaryColor,
              dotHeight: 8,
              dotWidth: 16,
              dotColor: Colors.grey.withOpacity(0.3),
              // strokeWidth: 5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(
            AppSize.s18,
          ),
          child: ElevatedButton(
            onPressed: () => splashItem.id != splashLength
                ? setNewPage(splashItem.id)
                : Navigator.of(context)
                    .pushReplacementNamed(RouteManager.authScreen),
            child:
                Text(splashItem.id != splashLength ? "Next" : "Let's start!"),
          ),
        ),
      ],
    );
  }

  // SplashText
  Text splashText({required String title}) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: getHeadingStyle(
        color: fontColor,
      ),
    );
  }
}
