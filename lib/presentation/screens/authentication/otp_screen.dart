// lib/presentation/screens/authentication/otp_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_app/widgets/auth_button.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import 'location_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final String userId;

  const OtpScreen({
    super.key,
    required this.phone,
    required this.userId,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String get otp => _controllers.map((e) => e.text.trim()).join();

  void verifyOtp() {
    if (otp.length != 6) {
      CustomSnackBar.show(context, StringResources.completeOtpRequired, isError: true);
      return;
    }
    context.read<AuthBloc>().add(VerifyOtpEvent(widget.phone.trim(), otp));
  }

  void resendOtp() {
    context.read<AuthBloc>().add(SendOtpEvent(widget.phone, widget.userId));
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is OtpVerifiedState) {
            CustomSnackBar.show(context, state.message, isError: false);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LocationScreen()),
                  (route) => false,
            );
          }

          if (state is AuthFailure) {
            CustomSnackBar.show(context, state.error, isError: true);
          }
        },

        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  /// TITLE
                  Text(
                    "Verification",
                    style: GoogleFonts.dmSans(
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkPrimaryText,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// SUBTITLE
                  Text(
                    "Enter the 6-digit code sent to your number\n"
                        "${StringResources.countryCodePk} ${widget.phone}",
                    style: GoogleFonts.dmSans(
                      fontSize: 15.sp,
                      color: AppColors.lightText,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  /// OTP BOXES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) => _buildOtpBox(index)),
                  ),

                  SizedBox(height: 32.h),

                  /// RESEND
                  Center(
                    child: TextButton(
                      onPressed: isLoading ? null : resendOtp,
                      child: RichText(
                        text: TextSpan(
                          text: "Didn't receive code? ",
                          style: GoogleFonts.dmSans(
                            color: AppColors.lightText,
                            fontSize: 14.sp,
                          ),
                          children: [
                            TextSpan(
                              text: "Resend",
                              style: GoogleFonts.dmSans(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  /// ROUND ACTION BUTTON (REPLACEMENT OF AuthButton)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: isLoading ? null : verifyOtp,
                      borderRadius: BorderRadius.circular(30.r),

                      child: Container(
                        height: 56.h,
                        width: 56.w,
                        decoration: BoxDecoration(
                          color:
                          isLoading ? Colors.grey : AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (!isLoading)
                              BoxShadow(
                                color:
                                AppColors.primary.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                          ],
                        ),

                        child: isLoading
                            ? Padding(
                          padding: EdgeInsets.all(12.r),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    final bool isFocused = _focusNodes[index].hasFocus;
    return Container(
      width: 48.w,
      height: 58.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused ? AppColors.primary : AppColors.border,
          width: 2,
        ),
        boxShadow: isFocused ? [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ] : [],
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: GoogleFonts.dmSans(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.black,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {}); // Updates border color on focus change
        },
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isCollapsed: true, // Fixes digit vertical alignment issues
        ),
      ),
    );
  }
}