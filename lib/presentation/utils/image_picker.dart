import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:plantly/resources/styles_manager.dart';
import '../../constants/enums/image_source.dart';
import '../../constants/color.dart';
import '../../resources/font_manager.dart';
import '../../resources/values_manager.dart';

class ImagePickerUtil extends StatelessWidget {
  const ImagePickerUtil({
    Key? key,
    required this.icon,
    required this.imageSource,
    required this.pickImageFnc,
    required this.title,
  }) : super(key: key);
  final IconData icon;
  final String title;
  final ImagePathSource imageSource;
  final Function pickImageFnc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickImageFnc(imageSource),
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        dashPattern: const [3, 6],
        color: primaryColor,
        radius: const Radius.circular(12),
        padding: const EdgeInsets.all(6),
        child: Container(
          decoration: BoxDecoration(
            color: bgLiteColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: AppSize.s50,
                    color: primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: primaryColor,
                      fontSize: FontSize.s16,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
