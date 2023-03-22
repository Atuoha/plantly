import 'package:flutter/material.dart';
import '../../constants/color.dart';
import '../../constants/enums/fields.dart';
import '../../resources/values_manager.dart';

// textField
Widget kTextField({
  required TextEditingController controller,
  required String title,
  required int maxLine,
  required Field textField,
}) {
  return TextFormField(
    controller: controller,
    validator: (value) {
      if (value!.isEmpty) {
        return '$title can not be empty!';
      }
      return null;
    },
    textInputAction: textField == Field.title
        ? TextInputAction.next
        : TextInputAction.newline,
    maxLines: maxLine,
    decoration: InputDecoration(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
        borderRadius: BorderRadius.circular(AppSize.s20),
      ),
    ),
  );
}
