import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../constants/enums/image_source.dart';
import '../../constants/color.dart';
import '../../resources/values_manager.dart';

class ImagePickerUtil extends StatelessWidget {
  const ImagePickerUtil({
    Key? key,
    required this.icon,
    required this.imageSource,
    required this.pickImageFnc,
  }) : super(key: key);
  final IconData icon;
  final ImagePathSource imageSource;
  final Function pickImageFnc;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      borderType: BorderType.RRect,
      color: primaryColor,
      radius: const Radius.circular(12),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
        child: SizedBox(
          height: 200,
          child: Align(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: () => pickImageFnc(imageSource),
              icon: Icon(
                icon,
                size: AppSize.s50,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
