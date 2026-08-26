import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/extension/validation_extension.dart';
import 'package:grocery_app/presentation/bloc/auth/auth_event.dart';
import 'package:grocery_app/presentation/screens/authentication/forget_password.dart';
import 'package:grocery_app/presentation/screens/authentication/signup_screen.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

import '../../../core/enums/otp_purpose.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/images-resources.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../core/routes/AppRoutes.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_state.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? phone;
  final String? password;
  const LoginScreen({
    super.key,
    this.phone,
    this.password,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();

    phoneController.text = widget.phone ?? '';
    passwordController.text = widget.password ?? '';
  }

  Future<void> loginUser() async {

    if (!_formKey.currentState!.validate()) return;
    final phone = phoneController.text.formatPhone();
    context.read<AuthBloc>().add(
      LoginEvent(phone, passwordController.text.trim()),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            final user = state.data.user;

            if (user.isPhoneVerified == false) {
              context.read<AuthBloc>().add(
                SendOtpEvent(
                  userId: user.id,
                  type: OtpType.phone,
                  value: phoneController.text.formatPhone(),
                  purpose: OtpPurpose.phoneVerification,
                ),
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                    (route) => false,
              );
            }
          }

          if (state is OtpSentState) {
            CustomSnackBar.show(
              context,
              state.message,
              isError: false,
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OtpScreen(
                  value: phoneController.text.formatPhone(),
                  userId: state.userId!,
                  purpose: OtpPurpose.phoneVerification,
                  type: OtpType.phone,
                ),
              ),
            );
          }

          if (state is AuthFailure) {
            CustomSnackBar.show(
              context,
              state.error,
              isError: true,
            );
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
                    SizedBox(height: 50.h),
                    Center(
                      child: Image.asset(
                        ImageResource.OMINGO_LOCATION_LOGO_IMG,
                        height: 120.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 40.h),
                    Text(
                      StringResources.login,
                      style: GoogleFonts.dmSans(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkPrimaryText,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      StringResources.enterPhonePassword,
                      style: GoogleFonts.dmSans(
                        color: AppColors.lightText,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 32.h),

                    AuthTextField(
                      label: StringResources.mobileNumber,
                      hint:StringResources.phoneHint,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      prefixText: "+92",
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          "🇵🇰",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      validator: (v) => v.validatePhone(),
                    ),
                    SizedBox(height: 20.h),

                    AuthTextField(
                      label: StringResources.password,
                      hint: "Enter your secure password",
                      controller: passwordController,
                      obscure: true,
                      validator: (v) => v.validatePassword(),
                    ),

                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Safe access to ID if state is AuthSuccess, else pass empty string
                          String userId = "";
                          if (state is AuthSuccess) {
                            userId = state.data.user.id;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => ForgetPassword()),
                          );
                        },
                        child: Text(
                          StringResources.forgotPassword,
                          style: GoogleFonts.dmSans(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    AuthButton(
                      text: StringResources.login,
                      isLoading: state is AuthLoading,
                      onTap: loginUser,
                    ),

                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          StringResources.dontHaveAccount,
                          style: GoogleFonts.dmSans(
                            color: AppColors.lightText,
                            fontSize: 14.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: Text(
                            "  ${StringResources.signUp}",
                            style: GoogleFonts.dmSans(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
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
