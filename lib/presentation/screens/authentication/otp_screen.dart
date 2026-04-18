import 'package:flutter/material.dart';
import 'package:grocery_app/core/services/auth_service.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/sizes.dart';
import 'location_screen.dart';


class OtpScreen extends StatefulWidget {
  final String phone;
  final String userId;

  const OtpScreen({super.key, required this.phone, required this.userId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController d1 = TextEditingController();
  final TextEditingController d2 = TextEditingController();
  final TextEditingController d3 = TextEditingController();
  final TextEditingController d4 = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? validateDigit(String? value) {
    if (value == null || value.isEmpty) return "";
    if (!RegExp(r'^[0-9]$').hasMatch(value)) return "";
    return null;
  }

  String get otp => d1.text + d2.text + d3.text + d4.text;

  Future<void> verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter complete 4-digit OTP")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await _authService.verifyOtp(
        userId: widget.userId,
        otp: otp,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP Verified")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LocationScreen()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> resendOtp() async {
    try {
      await _authService.sendOtp(userId: widget.userId, phone: widget.phone);

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("OTP resent")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget otpBox(TextEditingController controller) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        validator: validateDigit,
        decoration: const InputDecoration(
          counterText: "",
          border: UnderlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios_sharp),
              ),

              const SizedBox(height: 30),

              const Text(
                "Enter your 4-digit code",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                "+92 ${widget.phone}",
                style: const TextStyle(color: AppColors.lightText),
              ),

              const SizedBox(height: 40),

              /// OTP Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [otpBox(d1), otpBox(d2), otpBox(d3), otpBox(d4)],
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: resendOtp,
                child: const Text(
                  "Resend Code",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: isLoading ? null : verifyOtp,
                  child: Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: isLoading ? Colors.grey : AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
