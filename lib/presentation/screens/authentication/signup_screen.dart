// lib/presentation/pages/auth/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/extension/validation_extension.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_bloc.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_event.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_state.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/images-resources.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../widgets/custom_snackbar.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signup() {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
      SignupEvent(
        nameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            CustomSnackBar.show(context, state.message, isError: false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }

          if (state is AuthFailure) {
            CustomSnackBar.show(context, state.error, isError: true);
          }
        },

        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Center(
                      child: Image.asset(
                        ImageResource.OMINGO_LOCATION_LOGO_IMG,
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      StringResources.signUp,
                      style: GoogleFonts.dmSans(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPrimaryText,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    Text(
                      StringResources.enterCredentials,
                      style: GoogleFonts.dmSans(
                        color: AppColors.lightText,
                        fontSize: 14.sp,
                      ),
                    ),

                    SizedBox(height: 32.h),

                    AuthTextField(
                      label: StringResources.username,
                      hint: "Enter your full name",
                      controller: nameController,
                      validator: (v) => v.validateName(),
                    ),

                    SizedBox(height: 20.h),

                    AuthTextField(
                      label: StringResources.email,
                      hint: "example@gmail.com",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v.validateEmail(),
                    ),

                    SizedBox(height: 20.h),

                    AuthTextField(
                      label: StringResources.password,
                      hint: "••••••••",
                      controller: passwordController,
                      validator: (v) => v.validatePassword(),
                      obscure: true,
                    ),

                    SizedBox(height: 20.h),

                    /// TERMS
                    RichText(
                      text: TextSpan(
                        text: StringResources.termsAndConditionsText,
                        style: GoogleFonts.dmSans(
                          fontSize: 13.sp,
                          color: AppColors.lightText,
                        ),
                        children: [
                          TextSpan(
                            text: StringResources.termsOfService,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: StringResources.and),
                          TextSpan(
                            text: StringResources.privacyPolicy,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    AuthButton(
                      text: StringResources.signUp,
                      isLoading: state is AuthLoading,
                      onTap: signup,
                    ),

                    SizedBox(height: 24.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringResources.alreadyHaveAccount,
                          style: GoogleFonts.dmSans(
                            color: AppColors.lightText,
                            fontSize: 14.sp,
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "  ${StringResources.login}",
                            style: GoogleFonts.dmSans(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
