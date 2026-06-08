import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/extension/validation_extension.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_event.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_state.dart';
import 'package:grocery_app/presentation/screens/authentication/login_screen.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/dimensions-resource.dart';
import '../../../core/helper/constants/strings-resource.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String userId;
  const ResetPasswordScreen({super.key, required this.userId});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void resetPassword() {
    if (!_formKey.currentState!.validate()) return;

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    context.read<AuthBloc>().add(
          ResetPasswordEvent(
            widget.userId,
            passwordController.text.trim(),
          ),
        );
  }

  @override
  void dispose() {
    otpController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          }
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error.replaceAll("Exception: ", ""))),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(DimensionsResources.D_16.r),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: DimensionsResources.D_20.h),
                  Text(
                    "Reset Password",
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: DimensionsResources.FONT_SIZE_TITLE_LARGE.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_10.h),
                  Text(
                    "Check your mail for the OTP and enter your new password below",
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightText,
                      fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_30.h),
                  AuthTextField(
                    label: StringResources.password,
                    controller: passwordController,
                    obscure: true,
                    validator: (v) => v.validatePassword(),
                  ),
                  SizedBox(height: DimensionsResources.D_20.h),
                  AuthTextField(
                    label: "Confirm Password",
                    controller: confirmPasswordController,
                    obscure: true,
                    validator: (v) => v.validatePassword(),
                  ),
                  SizedBox(height: DimensionsResources.D_40.h),
                  state is AuthLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AuthButton(
                          text: "Update Password",
                          onTap: resetPassword,
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
