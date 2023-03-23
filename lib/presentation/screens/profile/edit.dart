import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/profile/profile_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/image_source.dart';
import '../../../models/user.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../widgets/cool_alert.dart';
import '../../widgets/text_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isObscured2 = true;

  User user = User.initial();
  bool isImageSelected = false;
  String? downloadLink;
  bool isPasswordToBeUpdated = false;

  final _picker = ImagePicker();
  XFile? image;
  File? selectedImage;

  updateDetails() {
    setState(() {
      fullNameController.text = user.fullname;
      emailController.text = user.email;
    });
  }

  @override
  void initState() {
    setState(() {
      user = context.read<ProfileCubit>().state.user;
    });
    passwordController.addListener(() {
      setState(() {});
    });
    passwordController2.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    updateDetails();
    super.didChangeDependencies();
  }

  void selectImageSource() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Select Image source',
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s16,
          ),
        ),
        content: const Text(
            'Select the source of the image to be used for the profile image'),
        actions: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => selectImage(ImagePathSource.camera),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Camera'),
            ),
          ),
          Directionality(
            textDirection: TextDirection.rtl,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => selectImage(ImagePathSource.gallery),
              icon: const Icon(Icons.photo, color: Colors.white),
              label: const Text('Gallery'),
            ),
          ),
        ],
      ),
    );
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
      });
    }

    setState(() {
      image = pickedImage;
      selectedImage = File(pickedImage!.path);
    });
  }

  submitProfileEdit() {
    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    var userId = context.read<AuthBloc>().state.user!.uid;

    if (selectedImage != null) {
      // upload profile image to storage
      try {
        var storageRef = FirebaseStorage.instance.ref('users/$userId.jpg');
        storageRef.putFile(File(selectedImage!.path)).whenComplete(() async {
          downloadLink = await storageRef.getDownloadURL();
        });
      } on FirebaseException catch (e) {
        kCoolAlert(
          message: 'Opps! ${e.message}',
          context: context,
          alert: CoolAlertType.error,
        );
      }
    }

    // update profile details
    context.read<ProfileCubit>().editProfile(
          userId: userId,
          email: emailController.text.trim(),
          fullName: fullNameController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => submitProfileEdit(),
        backgroundColor: primaryColor,
        child: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
        ),
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
          'Edit Profile',
          style: getMediumStyle(
            color: fontColor,
            fontSize: FontSize.s20,
          ),
        ),
      ),
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, litePlantColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.13, 0.1],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: isImageSelected
                                ? Image.file(
                                    File(
                                      image!.path,
                                    ),
                                    width: 150,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    user.profileImg,
                                    fit: BoxFit.cover,
                                    width: 150,
                                  ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 3,
                            child: GestureDetector(
                              onTap: () => selectImageSource(),
                              child: const CircleAvatar(
                                backgroundColor: primaryColor,
                                child: Icon(
                                  Icons.restart_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.fullname,
                        style: getMediumStyle(
                          color: fontColor,
                          fontSize: FontSize.s18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.email,
                        style: getRegularStyle(
                          color: Colors.grey,
                          fontSize: FontSize.s16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Edit Data',
                  style: getMediumStyle(
                    color: fontColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      KTextField(
                        controller: fullNameController,
                        hintText: 'Enter your fullname',
                        label: 'Fullname',
                        field: Field.fullname,
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      KTextField(
                        controller: emailController,
                        hintText: 'Enter your email address',
                        label: 'Email',
                        field: Field.email,
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: 20),
                      CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            isPasswordToBeUpdated
                                ? 'Do you not want to update your password '
                                : 'Do you want to update your password?',
                            style: getMediumStyle(
                              color: fontColor,
                              fontSize: FontSize.s16,
                            ),
                          ),
                          checkColor: Colors.white,
                          activeColor: primaryColor,
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          value: isPasswordToBeUpdated,
                          onChanged: (value) {
                            setState(() {
                              isPasswordToBeUpdated = value!;
                            });
                          }),
                      AnimatedOpacity(
                        opacity: isPasswordToBeUpdated ? 1 : 0,
                        duration: const Duration(seconds: 2),
                        child: Column(
                          children: [
                            KTextField(
                              controller: passwordController,
                              hintText: 'Enter your password',
                              label: 'Password',
                              field: Field.password,
                              prefixIcon: Icons.lock,
                              isObscured: isObscured,
                            ),
                            const SizedBox(height: 20),
                            KTextField(
                              controller: passwordController2,
                              hintText: 'Reenter your password',
                              label: 'Confirm Password',
                              field: Field.password2,
                              prefixIcon: Icons.lock,
                              isObscured: isObscured2,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
