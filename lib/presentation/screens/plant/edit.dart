import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plantly/models/plant.dart';
import '../../../business_logic/plant/plant_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/image_source.dart';
import '../../../constants/enums/process_status.dart';
import '../../../constants/enums/status.dart';
import '../../../models/success.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../utils/image_picker.dart';
import '../../widgets/cool_alert.dart';
import '../../widgets/loading.dart';
import '../../widgets/message_snackbar.dart';
import '../../widgets/plant_task_text_field.dart';
import '../../widgets/success_dialog.dart';
import 'package:path/path.dart' as path;

class EditPlantScreen extends StatefulWidget {
  const EditPlantScreen({Key? key, required this.plant}) : super(key: key);
  final DocumentSnapshot plant;

  static const routeName = '/editPlant';

  @override
  State<EditPlantScreen> createState() => _EditPlantScreenState();
}

class _EditPlantScreenState extends State<EditPlantScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _picker = ImagePicker();
  XFile? image;
  File? selectedImage;
  bool isImageSelected = false;
  bool isImageEdited = false;
  String? downloadLink;

  double waterLevel = 1;
  double sunLevel = 1;

  void setDetails() {
    setState(() {
      titleController.text = widget.plant['title'];
      descriptionController.text = widget.plant['description'];
      waterLevel = double.parse(widget.plant['waterLevel'].toString());
      sunLevel = double.parse(widget.plant['sunLevel'].toString());
      downloadLink = widget.plant['imgUrl'];
    });
  }

  @override
  void initState() {
    setDetails();
    super.initState();
  }

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
        isImageEdited =  true;
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
      isImageEdited = true;
    });
  }

  void submitPlant() async {
    final model = context.read<PlantCubit>();

    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    if (isImageSelected) {
      try {
        // upload image to storage
        var storageRef = FirebaseStorage.instance
            .ref('plants/${path.basename(selectedImage!.path)}');
        await storageRef
            .putFile(File(selectedImage!.path))
            .whenComplete(() async {
          downloadLink = await storageRef.getDownloadURL();
        });
      } catch (e) {
        if (kDebugMode) {
          print('Error occurred');
        }
      }
    }

    var userId = FirebaseAuth.instance.currentUser!.uid;

    Plant plant = Plant(
      id: DateTime.now().toString(),
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      imgUrl: downloadLink!,
      waterLevel: int.parse(waterLevel.toStringAsFixed(0)),
      sunLevel: int.parse(waterLevel.toStringAsFixed(0)),
      userId: userId,
      date: DateTime.now(),
    );

    model.editPlant(plant: plant, id: widget.plant['id']);
    resetForm();
  }

  void resetForm() {
    setState(() {
      isImageSelected = false;
      titleController.clear();
      descriptionController.clear();
    });
    Navigator.of(context).pop(true);
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
          'Editing ${widget.plant['title']}',
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
        child: SingleChildScrollView(
          child: BlocListener<PlantCubit, PlantState>(
            listener: (context, state) {
              if (state.status == ProcessStatus.loading) {
                showDialog(
                  context: context,
                  builder: (context) => const LoadingWidget(),
                );
              } else if (state.status == ProcessStatus.success) {
                kCoolAlert(
                  message: '${titleController.text} successfully edited!',
                  context: context,
                  alert: CoolAlertType.success,
                  action: resetForm,
                );
              } else if (state.status == ProcessStatus.error) {
                kCoolAlert(
                  message:
                      '${titleController.text} can not be edited.\n ${state.error}!',
                  context: context,
                  alert: CoolAlertType.error,
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Photo',
                  style: getRegularStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                const SizedBox(height: 5),
                isImageEdited && !isImageSelected
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
                                child: isImageEdited
                                    ? Image.file(
                                        File(image!.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(downloadLink!,fit: BoxFit.cover),
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
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Title',
                        style: getRegularStyle(
                          color: fontColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      kTextField(
                        controller: titleController,
                        title: 'Title',
                        textField: Field.title,
                        maxLine: 1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description',
                        style: getRegularStyle(
                          color: fontColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      const SizedBox(height: 10),
                      kTextField(
                        controller: descriptionController,
                        title: 'Description',
                        textField: Field.description,
                        maxLine: 6,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Water Level 💦',
                            style: getRegularStyle(
                              color: fontColor,
                              fontSize: FontSize.s18,
                            ),
                          ),
                          Text(
                            'Sun Level 🌞',
                            style: getRegularStyle(
                              color: fontColor,
                              fontSize: FontSize.s18,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: waterLevel,
                              max: 5,
                              min: 0,
                              onChanged: (value) => setState(() {
                                waterLevel = value;
                              }),
                              onChangeEnd: (value) {
                                displaySnackBar(
                                  status: Status.success,
                                  message:
                                      'Water level set to ${waterLevel.toStringAsFixed(0)}',
                                  context: context,
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: sunLevel,
                              max: 5,
                              min: 0,
                              onChanged: (value) => setState(() {
                                sunLevel = value;
                              }),
                              onChangeEnd: (value) {
                                displaySnackBar(
                                  status: Status.success,
                                  message:
                                      'Sun level set to ${sunLevel.toStringAsFixed(0)}',
                                  context: context,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () => submitPlant(),
                        child: const Text('Add a plant'),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
