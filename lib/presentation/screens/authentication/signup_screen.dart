import 'package:flutter/material.dart';
import 'package:grocery_app/core/services/auth_service.dart';
import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/sizes.dart';
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
  final AuthService _authService = AuthService();
  bool isLoading = false;

  /// SIGNUP API CALL

  Future<void> signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _authService.signup(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      if (!mounted) return;

      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response["msg"])));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    }
  }

  /// VALIDATIONS (MATCH BACKEND)

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password is required";
    }
    if (value.length < 6) {
      return "Minimum 6 characters required";
    }
    /*if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain a number";
    }*/
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.padding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100),

                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Enter your credentials to continue",
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// NAME
                    AuthTextField(
                      label: "Username",
                      controller: nameController,
                      validator: validateName,
                    ),

                    const SizedBox(height: 20),

                    /// EMAIL
                    AuthTextField(
                      label: "Email",
                      controller: emailController,
                      validator: validateEmail,
                    ),

                    const SizedBox(height: 20),

                    /// PASSWORD
                    AuthTextField(
                      label: "Password",
                      controller: passwordController,
                      validator: validatePassword,
                      obscure: true,
                    ),

                    const SizedBox(height: 20),

                    RichText(
                      text: const TextSpan(
                        text: "By continuing you agree to our ",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.lightText,
                        ),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AuthButton(text: "Sign Up", onTap: signup),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: AppColors.lightText),
                        ),
                        GestureDetector(
                          child: Text(
                            "Sign in",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginScreen();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
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
