import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/forgot_password/forgot_password_cubit.dart';
import '../../../constants/color.dart';
import '../../../constants/enums/fields.dart';
import '../../../constants/enums/process_status.dart';
import '../../../resources/route_manager.dart';
import '../../../resources/string_manager.dart';
import '../../../resources/styles_manager.dart';
import '../../../resources/values_manager.dart';
import '../../widgets/action_wrap.dart';
import '../../widgets/error_dialog.dart';
import '../../widgets/loading.dart';
import '../../widgets/success_dialog.dart';
import '../../widgets/text_field.dart';
import '../../../models/success.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
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

    context.read<ForgotPasswordCubit>().forgotPassword(
          email: emailController.text.trim(),
        );
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
              child: BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
                listener: (context, state) {
                  if (state.status == ProcessStatus.loading) {
                    const LoadingWidget();
                  } else if (state.status == ProcessStatus.error) {
                    errorDialog(context: context, error: state.error);
                  } else if (state.status == ProcessStatus.success) {
                    successDialog(
                      context: context,
                      success: Success(
                        title: 'Reset Link Sent',
                        description: 'Reset link has been sent successfully',
                      ),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppString.forgotPasswordTitle,
                      style: getHeadingStyle(
                        color: fontColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      AppString.forgotPasswordSubtitle,
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
                            controller: emailController,
                            hintText: 'Enter your email address',
                            label: 'Email',
                            field: Field.email,
                            prefixIcon: Icons.email,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => submitAuthForm(),
                            child: const Text('Restore password'),
                          ),
                          const SizedBox(height: 10),
                          ActionWrap(
                            title: 'Remembered password?',
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
      ),
    );
  }
}
