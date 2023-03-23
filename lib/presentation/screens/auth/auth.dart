import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plantly/constants/enums/fields.dart';
import 'package:plantly/presentation/widgets/loading.dart';
import 'package:plantly/resources/styles_manager.dart';

import '../../../business_logic/auth_bloc/auth_bloc.dart';
import '../../../business_logic/google_auth/google_auth_cubit.dart';
import '../../../business_logic/sign_in/sign_in_cubit.dart';
import '../../../business_logic/sign_up/sign_up_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/auth_status.dart';
import '../../../constants/enums/process_status.dart';
import '../../../resources/assets_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/action_wrap.dart';
import '../../widgets/cool_alert.dart';
import '../../widgets/error_dialog.dart';
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

  void submitAuthForm() {
    FocusScope.of(context).unfocus();
    var valid = formKey.currentState!.validate();
    if (!valid) {
      return;
    }

    if (isSignInState) {
      // sign in
      context.read<SignInCubit>().signIn(
            email: emailController.text,
            password: passwordController.text,
          );
    } else {
      // sign up

      context.read<SignUpCubit>().signUp(
            email: emailController.text,
            password: passwordController.text,
            fullName: fullNameController.text,
          );
    }
  }

  void googleAuthenticate() {
    // google authenticate
    context.read<GoogleAuthCubit>().googleAuth();
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
            child: SingleChildScrollView(
              child: MultiBlocListener(
                listeners: [
                  // Sign in
                  BlocListener<SignInCubit, SignInState>(
                      listener: (context, state) {
                    if (state.status == ProcessStatus.loading) {
                      kCoolAlert(
                        message: 'Loading...please wait',
                        context: context,
                        alert: CoolAlertType.loading,
                      );
                    } else if (state.status == ProcessStatus.error) {
                      errorDialog(context: context, error: state.error);
                      kCoolAlert(
                        message: 'An error occurred! ${state.error}!',
                        context: context,
                        alert: CoolAlertType.error,
                      );
                    }
                  }),

                  // Sign up
                  BlocListener<SignUpCubit, SignUpState>(
                      listener: (context, state) {
                    if (state.status == ProcessStatus.loading) {
                      kCoolAlert(
                        message: 'Loading...please wait',
                        context: context,
                        alert: CoolAlertType.loading,
                      );
                    } else if (state.status == ProcessStatus.error) {
                      errorDialog(context: context, error: state.error);
                      kCoolAlert(
                        message: 'An error occurred! ${state.error}!',
                        context: context,
                        alert: CoolAlertType.error,
                      );
                    }
                  }),

                  // google Auth
                  BlocListener<GoogleAuthCubit, GoogleAuthState>(
                      listener: (context, state) {
                    if (state.status == ProcessStatus.loading) {
                      kCoolAlert(
                        message: 'Loading...please wait',
                        context: context,
                        alert: CoolAlertType.loading,
                      );
                    } else if (state.status == ProcessStatus.error) {
                      errorDialog(context: context, error: state.error);
                      kCoolAlert(
                        message: 'An error occurred! ${state.error}!',
                        context: context,
                        alert: CoolAlertType.error,
                      );
                    }
                  }),

                  // Auth bLOC
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state.authStatus == AuthStatus.authenticated) {
                        Navigator.of(context)
                            .pushNamed(RouteManager.homeScreen);
                      }
                    },
                  ),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      isSignInState
                          ? AppString.welcomeText
                          : AppString.signupTitle,
                      style: getHeadingStyle(
                        color: fontColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isSignInState
                          ? AppString.signInSubtitle
                          : AppString.signUpSubTitle,
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
                          AnimatedOpacity(
                            opacity: isSignInState ? 0 : 1,
                            duration: const Duration(seconds: 2),
                            child: KTextField(
                              controller: fullNameController,
                              hintText: 'Enter your fullname',
                              label: 'Fullname',
                              field: Field.fullname,
                              prefixIcon: Icons.person,
                            ),
                          ),
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
                            onPressed: () => submitAuthForm(),
                            child: Text(isSignInState ? 'Sign In' : 'Sign Up'),
                          ),
                          const SizedBox(height: 10),
                          ActionWrap(
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
                            onPressed: () => googleAuthenticate(),
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
                          ActionWrap(
                            title: isSignInState
                                ? "Don't have an account?"
                                : "Already have an account?",
                            actionTitle: isSignInState ? "Create" : "Sign In",
                            action: switchSignState,
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
      ),
    );
  }
}
