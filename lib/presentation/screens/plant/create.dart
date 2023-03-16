import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../constants/color.dart';
import '../../../constants/enums/image_source.dart';
import '../../../models/success.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../utils/image_picker.dart';
import '../../widgets/success_dialog.dart';

class CreatePlantScreen extends StatefulWidget {
  const CreatePlantScreen({Key? key}) : super(key: key);

  @override
  State<CreatePlantScreen> createState() => _CreatePlantScreenState();
}

class _CreatePlantScreenState extends State<CreatePlantScreen> {
  final _picker = ImagePicker();
  XFile? image;
  File? selectedImage;
  bool isImageSelected = false;

  Future selectImage(ImagePathSource source) async {
    XFile? pickedImage;
    switch (source) {
      case ImagePathSource.camera:
        pickedImage = await _picker.pickImage(source: ImageSource.camera);
        break;
      case ImagePathSource.gallery:
        pickedImage = await _picker.pickImage(source: ImageSource.gallery);
        break;
    }

    if (pickedImage == null) {
      return;
    } else {
      setState(() {
        isImageSelected = true;
      });
    }

    setState(() {
      image = pickedImage;
      selectedImage = File(pickedImage!.path);
    });
  }

  void resetIsImagePicked() {
    setState(() {
      isImageSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          IconButton(
            onPressed: () => successDialog(
              context: context,
              success: Success(
                title: 'Adding Plant info',
                description:
                    'Add plant by adding the image, title and description.',
              ),
            ),
            icon: const Icon(
              Icons.info,
              color: primaryColor,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 18.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Photo',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 5),
            !isImageSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ImagePickerUtil(
                          icon: Icons.camera_alt,
                          title: 'Take a photo',
                          pickImageFnc: selectImage,
                          imageSource: ImagePathSource.camera,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ImagePickerUtil(
                          icon: Icons.photo,
                          title: 'Choose from gallery',
                          pickImageFnc: selectImage,
                          imageSource: ImagePathSource.gallery,
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      DottedBorder(
                        borderType: BorderType.RRect,
                        strokeWidth: 2,
                        dashPattern: const [3, 6],
                        color: primaryColor,
                        radius: const Radius.circular(12),
                        padding: const EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          child: IconButton(
                            onPressed: () => resetIsImagePicked(),
                            icon: const Icon(
                              Icons.restart_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
