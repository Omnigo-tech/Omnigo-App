import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/extension/validation_extension.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_event.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_state.dart';
import 'package:grocery_app/presentation/screens/authentication/reset_password.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

import '../../../core/enums/otp_purpose.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/dimensions-resource.dart';
import '../../../core/helper/constants/strings-resource.dart';
import 'otp_screen.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController inputController = TextEditingController();

  void sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthBloc>().add(
        ForgotPasswordEvent(inputController.text.trim()));
  }

  @override
  void dispose() {
    inputController.dispose();
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
          if (state is OtpSentState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  value: inputController.text.trim(),
                  userId: state.userId!,
                  type: OtpType.email,
                  purpose: OtpPurpose.forgotPassword,
                ),
              ),
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
                  SizedBox(height: DimensionsResources.D_40.h),
                  Text(
                    StringResources.forgotPassword,
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: DimensionsResources.FONT_SIZE_TITLE_LARGE.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_10.h),
                  Text(
                    "Enter your email or phone number to reset your password",
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.lightText,
                      fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                    ),
                  ),
                  SizedBox(height: DimensionsResources.D_40.h),
                  AuthTextField(
                    label: "Email or Phone",
                    controller: inputController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter email or phone";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: DimensionsResources.D_40.h),
                  state is AuthLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AuthButton(
                          text: StringResources.next,
                          onTap: sendOtp,
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
