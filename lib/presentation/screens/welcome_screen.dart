import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/widgets/social_button.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../core/routes/AppRoutes.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_event.dart';
import '../bloc/auth/auth_state.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            final userData = state.data;
            final user = userData.user;

            if (user.hasLocation == false) {

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.location,
                    (route) => false,
              );
            } else {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.home,
                    (route) => false,
              );
            }
          }

          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(ImageResource.GROCERY_IMG),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Get your groceries\nwith nectar",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SocialButton(
                            text: "Create new account",
                            icon: Icons.g_mobiledata,
                            check: false,
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                          ),
                          const SizedBox(height: 15),
                          Center(
                            child: Text(
                              "Or connect with social media",
                              style: TextStyle(color: AppColors.lightText),
                            ),
                          ),
                          const SizedBox(height: 15),

                          // GOOGLE LOGIN BUTTON
                          SocialButton(
                            text: "Continue with Google",
                            icon: Icons.g_mobiledata,
                            check: true,
                            onTap: () {
                              context.read<AuthBloc>().add(GoogleLoginEvent());
                            },
                          ),

                          // FACEBOOK LOGIN BUTTON
                          SocialButton(
                            text: "Continue with Facebook",
                            icon: Icons.facebook,
                            check: true,
                            onTap: () {
                              context.read<AuthBloc>().add(FacebookLoginEvent());
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Loading Indicator jab API hit ho rhi ho
              if (state is AuthLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}