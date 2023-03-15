import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantly/presentation/widgets/success_dialog.dart';

import '../../../constants/color.dart';
import '../../../constants/enums/image_source.dart';
import '../../../models/success.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../utils/image_picker.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isImageSelected
          ? FloatingActionButton(
              backgroundColor: primaryColor,
              onPressed: () {},
              child: const Icon(
                Icons.document_scanner_outlined,
                color: Colors.white,
              ),
            )
          : const SizedBox.shrink(),
      appBar: AppBar(
        title: Text(
          'Scan Plant',
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
                title: 'Scan info',
                description:
                    'Scanning plants will give you information about plants and how best to care for them!',
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
              'Select the source of image',
              style: getMediumStyle(
                color: fontColor,
                fontSize: FontSize.s18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'To be able to scan a plan you will have to capture or select the plant to be scanned!',
              style: getLightStyle(
                color: fontColor,
              ),
            ),
            const SizedBox(height: 20),
            !isImageSelected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ImagePickerUtil(
                          icon: Icons.camera_alt,
                          pickImageFnc: selectImage,
                          imageSource: ImagePathSource.camera,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: ImagePickerUtil(
                          icon: Icons.photo,
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
