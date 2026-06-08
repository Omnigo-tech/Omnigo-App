// lib/presentation/pages/auth/phone_input_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/core/helper/extension/validation_extension.dart';
import 'package:grocery_app/widgets/auth_button.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/enums/otp_purpose.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/dimensions-resource.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../data/datasource/local/auth_local_data_source.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'otp_screen.dart';

class PhoneInputScreen extends StatefulWidget {

  const PhoneInputScreen({
    super.key,
  });

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final String? userId = sl<AuthLocalDataSource>().getUserId();

  /// SEND OTP
  void sendOtp() {
    if (!_formKey.currentState!.validate()) return;
    if (userId == null) {
      CustomSnackBar.show(context, "User ID not found. Please login again.", isError: true);
      return;
    }
    context.read<AuthBloc>().add(
      SendOtpEvent(
        userId: userId!,
        type: OtpType.phone,
        value: phoneController.text.trim(),
        purpose: OtpPurpose.phoneVerification,
      ),
    );
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.black),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          /// OTP SENT SUCCESS
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
                  value: phoneController.text.trim(),
                  userId: userId!,
                  purpose: OtpPurpose.phoneVerification,
                  type: OtpType.email,
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
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    /// TITLE
                    Text(
                      StringResources.enterMobileNumber,
                      style: GoogleFonts.inter(
                        fontSize: 24.sp,
                        color: AppColors.darkPrimaryText,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Text(
                      StringResources.verificationDescription,
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        color: AppColors.lightText,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: 40.h),

                    Text(
                      StringResources.mobileNumber,
                      style: GoogleFonts.dmSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkPrimaryText,
                      ),
                    ),

                    SizedBox(height: 8.h),

                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v.validatePhone(),
                      style: GoogleFonts.dmSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.2,
                      ),
                      decoration: InputDecoration(
                        hintText: StringResources.phoneHint,
                        prefixIcon: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          margin: EdgeInsets.only(right: 12.w),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: AppColors.border, width: 1),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                StringResources.countryCodePk,
                                style: GoogleFonts.dmSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.fieldBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: const BorderSide(color: Colors.red, width: 1),
                        ),
                      ),
                    ),

                    const Spacer(),

                    AuthButton(
                      text: "Get Code",
                      onTap: sendOtp,
                      isLoading: isLoading,
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
