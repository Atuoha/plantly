import 'package:flutter/material.dart';
import 'package:validators/validators.dart';
import '../../../../constants/enums/fields.dart';

class KTextField extends StatefulWidget {
  KTextField({
    Key? key,
    this.isObscured = false,
    required this.controller,
    required this.hintText,
    required this.label,
    required this.field,
    this.password = '',
    required this.prefixIcon,
  }) : super(key: key);
  final TextEditingController controller;
  final String hintText;
  final String label;
  final Field field;
  bool? isObscured;
  String? password;
  final IconData prefixIcon;

  @override
  State<KTextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<KTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      textInputAction: widget.field == Field.password
          ? TextInputAction.done
          : TextInputAction.next,
      controller: widget.controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText:
          widget.field == Field.password || widget.field == Field.password2
              ? widget.isObscured!
              : false,
      validator: (value) {
        if (widget.field == Field.fullname) {
          if (value!.isEmpty || value.length < 6) {
            return '${widget.label} needs to be valid';
          }
        } else if (widget.field == Field.password2) {
          if (value!.isEmpty) {
            return '${widget.label} can not be empty';
          }

          if (value != widget.password!) {
            return 'Password mismatch. Try again!';
          }

          if (value.length < 8) {
            return '${widget.label} needs to be valid';
          }
        } else if (widget.field == Field.email) {
          if (value!.isEmpty) {
            return '${widget.label} can not be empty';
          }
          if (!isEmail(value.trim())) {
            return '${widget.label} needs to be valid';
          }
        } else {
          if (value!.isEmpty) {
            return '${widget.label} can not be empty';
          }

          if (value.length < 8) {
            return '${widget.label} needs to be valid';
          }
        }

        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        label: Text(widget.label),
        prefixIcon: Icon(widget.prefixIcon),
        suffix:
            widget.field == Field.password || widget.field == Field.password2
                ? widget.controller.text.isNotEmpty
                    ? GestureDetector(
                        onTap: () => setState(() {
                          widget.isObscured = !widget.isObscured!;
                        }),
                        child: Icon(
                          widget.isObscured!
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )
                    : const SizedBox.shrink()
                : const SizedBox.shrink(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
