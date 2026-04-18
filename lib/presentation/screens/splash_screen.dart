import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../core/routes/AppRoutes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Omnigo",
                    style: TextStyle(
                      color: AppColors.border,
                      fontSize: 50,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 0),

                  const Text(
                    "Grocery App",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Tagline
                  const Text(
                    "Fresh groceries delivered fast",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                    SizedBox(height: 10),
                    Text("Loading...", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
