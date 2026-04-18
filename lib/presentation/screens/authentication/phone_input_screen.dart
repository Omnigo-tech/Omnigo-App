import 'package:flutter/material.dart';
import 'package:grocery_app/core/services/auth_service.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/sizes.dart';
import 'otp_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  final String id;
  const PhoneInputScreen({super.key, required this.id});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final TextEditingController phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone number is required";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Only digits allowed";
    }

    if (value.length != 10) {
      return "Must be 10 digits";
    }

    if (!value.startsWith('3')) {
      return "Must start with 3";
    }

    return null;
  }

  Future<void> sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _authService.sendOtp(
        userId: widget.id,
        phone: phoneController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response["msg"] ?? "OTP sent")));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            phone: '0${phoneController.text.trim()}',
            userId: widget.id,
          ),
        ),
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
                child: const Icon(Icons.arrow_back_ios_new),
              ),

              const SizedBox(height: 30),

              const Text(
                "Enter your mobile number",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "Mobile Number",
                style: TextStyle(fontSize: 15, color: AppColors.lightText),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  const Text("+92", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: validatePhone,
                      decoration: const InputDecoration(
                        hintText: "3XXXXXXXXX",
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: isLoading ? null : sendOtp,
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

/*import 'package:flutter/material.dart';
import 'package:grocery_app/presentation/screens/otp_screen.dart';
import '../../../core/constants/colors_resources.dart';
import '../../../core/constants/sizes.dart';

class PhoneInputScreen extends StatelessWidget {
  final String id;
  const PhoneInputScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            /// Back Arrow
            const Icon(Icons.arrow_back_ios_new),

            const SizedBox(height: 30),

            const Text(
              "Enter your mobile number",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Mobile Number",
              style: TextStyle(fontSize: 15, color: AppColors.lightText),
            ),

            /// Phone Input
            Row(
              children: const [
                Text("+92", style: TextStyle(fontSize: 16)),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const OtpScreen()),
                );
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

/*import 'package:flutter/material.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60),

            /// Back Button
            Icon(Icons.arrow_back),

            SizedBox(height: 20),

            Text(
              "Enter your mobile number",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            Row(
              children: [
                Text("+92"),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),

            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {},
                child: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
