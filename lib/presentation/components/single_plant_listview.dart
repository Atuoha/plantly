import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../resources/font_manager.dart';
import '../../resources/styles_manager.dart';
import '../../resources/values_manager.dart';

class SinglePlantListView extends StatelessWidget {
  const SinglePlantListView({
    Key? key,
    required this.size,
    required this.plant,
  }) : super(key: key);

  final Size size;
  final QueryDocumentSnapshot<Object?> plant;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: recentPlantBg,
          borderRadius: BorderRadius.circular(15),
        ),
        height: size.height / 5.1,
        child: Row(
          children: [
            SizedBox(
              width: size.width * 0.4,
              height: size.height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  plant['imgUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: AppSize.s10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      plant['title'],
                      style: getMediumStyle(
                        color: fontColor,
                        fontSize: FontSize.s18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    width: size.width / 2.3,
                    child: Text(
                      plant['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: fontColor,
                        fontSize: FontSize.s16,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
