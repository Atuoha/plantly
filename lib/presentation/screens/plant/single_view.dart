import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/presentation/screens/plant/edit.dart';
import 'package:plantly/resources/values_manager.dart';
import '../../../business_logic/plant/plant_cubit.dart';
import '../../../constants/color.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../utils/black_white_image_conversion.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import '../../widgets/are_you_sure_dialog.dart';

class SinglePlantScreen extends StatefulWidget {
  const SinglePlantScreen({
    Key? key,
    required this.plant,
    required this.plantDocId,
  }) : super(key: key);
  final DocumentSnapshot plant;
  final String plantDocId;

  @override
  State<SinglePlantScreen> createState() => _SinglePlantScreenState();
}

class _SinglePlantScreenState extends State<SinglePlantScreen>
    with SingleTickerProviderStateMixin {
  var emojiIndex = 0;

  void switchIndex(int index) {
    setState(() {
      emojiIndex = index;
    });
  }

  deletePlantAction(String plantId) {
    context.read<PlantCubit>().deletePlant(id: plantId);
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  void removePlantDialog(String plantName, String plantId) {
    areYouSureDialog(
      title: 'Delete $plantName',
      content: 'Are you sure you want to delete $plantName?',
      context: context,
      action: deletePlantAction,
      id: plantId,
      isIdInvolved: true,
    );
  }

  retrieveTaskLength() async {
    await context.read<PlantCubit>().taskLength(plantId: widget.plant['id']);
  }

  Animation<double>? _animation;
  AnimationController? _animationController;

  @override
  void initState() {
    retrieveTaskLength();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: _animationController!);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var remainingWaterLevel = 5 - widget.plant['waterLevel'];
    var remainingSunLevel = 5 - widget.plant['sunLevel'];

    return Scaffold(
      floatingActionButton: FloatingActionBubble(
        items: [
          Bubble(
            title: "Edit Plant",
            iconColor: Colors.white,
            bubbleColor: primaryColor,
            icon: Icons.edit_note,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditPlantScreen(
                  plant: widget.plant,
                ),
              ),
            ),
          ),
          Bubble(
            title: "Delete Plant",
            iconColor: Colors.white,
            bubbleColor: Colors.red,
            icon: Icons.delete_forever,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () => removePlantDialog(
              widget.plant['title'],
              widget.plantDocId,
            ),
          ),
        ],
        animation: _animation!,
        onPress: () => _animationController!.isCompleted
            ? _animationController!.reverse()
            : _animationController!.forward(),
        iconColor: Colors.white,
        iconData: Icons.chevron_right,
        backGroundColor: primaryColor,
      ),
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
                  widget.plant['imgUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              widget.plant['title'],
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s25,
              ),
            ),

            const SizedBox(height: 5),

            Text(
              widget.plant['title'],
              style: getRegularStyle(
                color: Colors.grey,
                fontSize: FontSize.s13,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              widget.plant['description'],
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
                        Wrap(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                widget.plant['waterLevel'],
                                (index) => const Icon(Icons.water_drop,
                                    color: waterIconBg),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                int.parse(remainingWaterLevel.toString()),
                                (index) => const Icon(Icons.water_drop,
                                    color: Colors.grey),
                              ),
                            ),
                          ],
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
                        Wrap(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                widget.plant['sunLevel'],
                                (index) =>
                                    const Icon(Icons.sunny, color: sunIconBg),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                int.parse(remainingSunLevel.toString()),
                                (index) =>
                                    const Icon(Icons.sunny, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
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
                          '${context.read<PlantCubit>().state.tasks} Tasks',
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
