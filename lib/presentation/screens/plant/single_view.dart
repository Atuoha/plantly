import 'package:flutter/material.dart';
import 'package:plantly/resources/values_manager.dart';
import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../utils/black_white_image_conversion.dart';

class SinglePlantScreen extends StatefulWidget {
  const SinglePlantScreen({Key? key}) : super(key: key);

  @override
  State<SinglePlantScreen> createState() => _SinglePlantScreenState();
}

class _SinglePlantScreenState extends State<SinglePlantScreen> {
  var emojiIndex = 0;

  void switchIndex(int index) {
    setState(() {
      emojiIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final plant = data['plant'];

    var remainingWaterLevel = 5 - plant['waterLevel'];
    var remainingSunLevel = 5 - plant['sunLevel'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
        ),
        title: Text(
          'Your Plants',
          style: getRegularStyle(
            color: fontColor,
            fontSize: FontSize.s25,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => switchIndex(0),
            child: emojiIndex == 0
                ? Image.asset(
                    'assets/images/love.png',
                    width: 40,
                  )
                : const BlackAndWhiteImage(
                    imageUrl: 'assets/images/love.png',
                    width: 40,
                  ),
          ),
          GestureDetector(
            onTap: () => switchIndex(1),
            child: emojiIndex == 1
                ? Image.asset(
                    'assets/images/angry.png',
                    width: 40,
                  )
                : const BlackAndWhiteImage(
                    imageUrl: 'assets/images/angry.png',
                    width: 40,
                  ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height / 3,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  plant['description'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plant['title'],
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s25,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Casamadus Freta',
              style: getRegularStyle(
                color: Colors.grey,
                fontSize: FontSize.s13,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              plant['description'],
              textAlign: TextAlign.justify,
              style: getRegularStyle(
                color: Colors.black,
                fontSize: FontSize.s16,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 80,
                  width: size.width / 2.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppSize.s18),
                      topLeft: Radius.circular(AppSize.s18),
                      bottomLeft: Radius.circular(AppSize.s18),
                    ),
                    color: waterContainerBg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Water',
                          style: getMediumStyle(
                            color: fontColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(
                            plant['waterLevel'],
                            (index) => const Icon(Icons.water_drop,
                                color: waterIconBg),
                          ),
                        ),
                        Row(
                          children: List.generate(
                            int.parse(remainingWaterLevel.toString()),
                            (index) => const Icon(Icons.water_drop,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: size.width / 2.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppSize.s18),
                      topLeft: Radius.circular(AppSize.s18),
                      bottomRight: Radius.circular(AppSize.s18),
                    ),
                    color: sunContainerBg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sun',
                          style: getMediumStyle(
                            color: fontColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: const [
                            Icon(Icons.sunny, color: sunIconBg),
                            Icon(Icons.sunny, color: sunIconBg),
                            Icon(Icons.sunny, color: sunIconBg),
                            Icon(Icons.sunny, color: sunIconBg),
                            Icon(Icons.sunny, color: Colors.grey),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // scanning and tasks
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 80,
                  width: size.width / 2.3,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSize.s18),
                      bottomRight: Radius.circular(AppSize.s18),
                      bottomLeft: Radius.circular(AppSize.s18),
                    ),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scanning',
                          style: getMediumStyle(
                            color: fontColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Last scanning',
                          style: getRegularStyle(
                            color: fontColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '04/21/23',
                          style: getRegularStyle(
                            color: fontColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 80,
                  width: size.width / 2.3,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(AppSize.s18),
                      bottomRight: Radius.circular(AppSize.s18),
                      bottomLeft: Radius.circular(AppSize.s18),
                    ),
                    color: recentPlantBg,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tasks',
                          style: getMediumStyle(
                            color: fontColor,
                            fontSize: FontSize.s16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '1 Task every week',
                          style: getUnderlineRegularStyle(
                            color: fontColor,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
