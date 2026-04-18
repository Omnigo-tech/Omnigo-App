import 'package:flutter/material.dart';
import 'package:grocery_app/data/models/user_model.dart';
import 'package:grocery_app/presentation/screens/authentication/phone_input_screen.dart';
import 'package:grocery_app/presentation/screens/authentication/signup_screen.dart';

import 'package:grocery_app/widgets/auth_button.dart';
import 'package:grocery_app/widgets/auth_textfield.dart';
import 'package:grocery_app/core/services/auth_service.dart';

import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/sizes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool isLoading = false;

  Future<void> loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      final user = UserModel.fromJson(response['user']);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response["msg"] ?? "Login successful")),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PhoneInputScreen(id: user.id)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
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
                    const SizedBox(height: 160),

                    const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      "Enter your email and password",
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 30),

                    AuthTextField(
                      label: "Email",
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        if (!value.contains("@")) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    AuthTextField(
                      label: "Password",
                      controller: passwordController,
                      obscure: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Minimum 6 characters required";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 5),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.lightText,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AuthButton(text: "Sign Up", onTap: loginUser),

                    /* AuthButton(
                      text: isLoading ? "Loading..." : "Log In",
                      onTap: isLoading ? null : loginUser,
                    ),*/
                    const SizedBox(height: 10),

                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(color: AppColors.lightText),
                        ),
                        GestureDetector(
                          child: Text(
                            "Sign Up",
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
                                  return SignupScreen();
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
