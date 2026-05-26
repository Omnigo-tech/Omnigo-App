import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart'; // Ensure strings are imported

import '../../../../core/helper/constants/colors_resources.dart';
import '../../../../core/helper/constants/strings-resource.dart';
import '../../../bloc/call/call_bloc.dart';
import '../../../bloc/call/call_event.dart';
import '../../../bloc/call/call_state.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<CallBloc, CallState>(
      listener: (context, state) {
        if (state.status == CallStatus.ended) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.callBackground,
        body: SafeArea(
          child: BlocBuilder<CallBloc, CallState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Top Info Icon
                  const Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(DimensionsResources.D_20),
                      child: Icon(
                          Icons.info_outline,
                          color: AppColors.white,
                          size: DimensionsResources.D_28
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Circular Avatar
                  Container(
                    height: DimensionsResources.D_180,
                    width: DimensionsResources.D_180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: AppColors.white.withOpacity(DimensionsResources.D_0_1),
                          width: DimensionsResources.D_2
                      ),
                      image: const DecorationImage(
                        image: AssetImage(ImageResource.CALL_USER_IMG),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: DimensionsResources.D_30),

                  Text(
                    state.userName.isEmpty
                        ? StringResources.defaultUserName
                        : state.userName,
                    style: textTheme.titleLarge?.copyWith(
                      color: AppColors.white, // Overriding color for dark background
                    ),
                  ),

                  const Spacer(flex: DimensionsResources.INT_2),

                  // Decline Button
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<CallBloc>().add(DeclineCall());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(DimensionsResources.D_20),
                          decoration: const BoxDecoration(
                            color: AppColors.callDeclineRed,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                              Icons.call_end,
                              color: AppColors.white,
                              size: DimensionsResources.D_36
                          ),
                        ),
                      ),
                      const SizedBox(height: DimensionsResources.D_10),

                      // Decline Label - Using bodyLarge from Theme
                      Text(
                        StringResources.decline,
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.whiteTranslucent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: DimensionsResources.D_60),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}