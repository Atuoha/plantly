import 'package:flutter/material.dart';
import 'package:plantly/constants/enums/fields.dart';
import 'package:plantly/resources/styles_manager.dart';

import '../../../constants/color.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, this.signIn = true}) : super(key: key);
  final bool signIn;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isSignInState = true;
  bool isObscured = true;

  @override
  void initState() {
    isSignInState = widget.signIn;
    passwordController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  void switchSignState() {
    setState(() {
      isSignInState = !isSignInState;
    });
  }

  void navigateToForgotPassword() {
    Navigator.of(context).pushNamed(RouteManager.forgotPasswordScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.s18,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isSignInState ? AppString.welcomeText : AppString.signupTitle,
                  style: getHeadingStyle(
                    color: fontColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  isSignInState
                      ? AppString.signInSubtitle
                      : AppString.signUpSubTitle,
                  style: getRegularStyle(
                    color: fontColor,
                  ),
                ),
                const SizedBox(height: 50),
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        !isSignInState
                            ? KTextField(
                                controller: fullNameController,
                                hintText: 'Enter your fullname',
                                label: 'Fullname',
                                field: Field.fullname,
                                prefixIcon: Icons.person,
                              )
                            : const SizedBox.shrink(),
                        SizedBox(height: !isSignInState ? 20 : 0),
                        KTextField(
                          controller: emailController,
                          hintText: 'Enter your email address',
                          label: 'Email',
                          field: Field.email,
                          prefixIcon: Icons.email,
                        ),
                        const SizedBox(height: 20),
                        KTextField(
                          controller: passwordController,
                          hintText: 'Enter your password',
                          label: 'Password',
                          field: Field.password,
                          prefixIcon: Icons.lock,
                          isObscured: isObscured,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(isSignInState ? 'Sign In' : 'Sign Up'),
                        ),
                        const SizedBox(height: 10),
                        buildWrap(
                          title: 'Forgot your password?',
                          actionTitle: 'Restore',
                          action: navigateToForgotPassword,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Or',
                            style: getRegularStyle(color: accentColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: liteGrey,
                          ),
                          onPressed: () {},
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Image.asset(
                                AssetManager.googleImage,
                                width: AppSize.s20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                isSignInState ? 'Sign In' : 'Sign up',
                                style: getRegularStyle(
                                  color: accentColor,
                                  fontSize: FontSize.s16,
                                  fontWeight: FontWeightManager.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildWrap(
                          title: isSignInState
                              ? "Don't have an account?"
                              : "Already have an account?",
                          actionTitle: isSignInState ? "Create" : "Sign In",
                          action: switchSignState,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // For navigating to forgot password and toggling signup/signin
  Center buildWrap({
    required String title,
    required String actionTitle,
    required Function action,
  }) {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            title,
            style: getRegularStyle(color: accentColor),
          ),
          const SizedBox(width: 2),
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: primaryColor),
              ),
            ),
            child: GestureDetector(
              onTap: () => action(),
              child: Text(
                actionTitle,
                style: const TextStyle(
                  color: primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
