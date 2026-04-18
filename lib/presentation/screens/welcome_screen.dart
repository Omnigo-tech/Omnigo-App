import 'package:flutter/material.dart';
import 'package:grocery_app/widgets/social_button.dart';

import '../../../core/helper/constants/colors_resources.dart';
import 'authentication/signup_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: //SingleChildScrollView(
            //child: SizedBox(
            //height: MediaQuery.of(context).size.height,
            //child:
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("images/grocery.png"),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Get your groceries\nwith nectar",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 20),

                        /// Phone Input
                        SocialButton(
                          text: "Create new account",
                          icon: Icons.g_mobiledata,
                          check: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignupScreen(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 15),

                        Center(
                          child: Text(
                            "Or connect with social media",
                            style: TextStyle(color: AppColors.lightText),
                          ),
                        ),

                        SizedBox(height: 15),

                        SocialButton(
                          text: "Continue with Google",
                          icon: Icons.g_mobiledata,
                          check: true,
                          onTap: () {},
                        ),

                        SocialButton(
                          text: "Continue with Facebook",
                          icon: Icons.facebook,
                          check: true,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ),
      //),
      //),
    );
  }
}
