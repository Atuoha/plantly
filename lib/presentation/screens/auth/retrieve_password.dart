import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../constants/enums/fields.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/action_wrap.dart';
import '../../widgets/text_field.dart';

class RetrievePasswordScreen extends StatefulWidget {
  const RetrievePasswordScreen({Key? key}) : super(key: key);

  @override
  State<RetrievePasswordScreen> createState() => _RetrievePasswordScreenState();
}

class _RetrievePasswordScreenState extends State<RetrievePasswordScreen> {
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isObscured = true;
  bool isObscured2 = true;

  @override
  void initState() {
    passwordController.addListener(() {
      setState(() {});
    });

    passwordController2.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void navigateToAuth() {
    Navigator.of(context).pushNamed(RouteManager.authScreen);
  }

  void submitAuthForm() {
    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }
  }

  void googleAuthenticate() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s18,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppString.retrievePasswordTitle,
                    style: getHeadingStyle(
                      color: fontColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppString.retrievePasswordSubtitle,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      color: fontColor,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          hintText: 'Confirm your password',
                          label: 'Password Confirmation',
                          field: Field.password2,
                          prefixIcon: Icons.lock,
                          isObscured: isObscured2,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => submitAuthForm(),
                          child: const Text('Proceed'),
                        ),
                        const SizedBox(height: 10),
                        ActionWrap(
                          title: 'Cancel this process?',
                          actionTitle: 'Sign in',
                          action: navigateToAuth,
                        ),
                      ],
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
