
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/helper/constants/colors_resources.dart';
import '../../../core/helper/constants/dimensions-resource.dart';
import '../../../core/helper/constants/images-resources.dart';
import '../../../core/helper/constants/strings-resource.dart';
import '../../../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../../../widgets/auth_button.dart';
import '../../../widgets/auth_textfield.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../bloc/location/location_bloc.dart';
import '../../bloc/location/location_event.dart';
import '../../bloc/location/location_state.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _bloc = sl<LocationBloc>();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadInitialDataEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showLocationDialog(context);
    });
  }
  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  void showLocationDialog(BuildContext screenContext) {
    GlobalDialogs.showStatusDialog(
      context: screenContext,
      isSuccess: true,
      imagePath: ImageResource.LOCATION_IMG,
      title: StringResources.useCurrentLocation,
      subtitle: StringResources.locationDialogSubtitle,
      primaryButtonText: StringResources.allowAccess,
      onPrimaryClick: () {
        Navigator.pop(screenContext);
        _bloc.add(FetchGpsLocationEvent());
      },
      secondaryButtonText: StringResources.enterManually,
      onSecondaryClick: () {
        Navigator.pop(screenContext);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocConsumer<LocationBloc, LocationState>(
          listener: (context, state) {
              if (state.errorMessage != null) {
                CustomSnackBar.show(context, state.errorMessage!, isError: true);
              }

              if (state.successMessage != null) {
                CustomSnackBar.show(context, state.successMessage!, isError: false);
                Navigator.pushNamed(context, AppRoutes.home);
              }

              if (state.detectedAddress != null && state.detectedAddress!.isNotEmpty) {
                _addressController.text = state.detectedAddress!;
              } else if (state.selectedZone == null) {
                _addressController.clear();
              }
          },
          builder: (context, state) {
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: 1.sh - MediaQuery.of(context).padding.top,
                      child: Padding(
                        padding: EdgeInsets.all(DimensionsResources.D_16.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: DimensionsResources.D_10.h),

                            /// BACK NAVIGATION
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: DimensionsResources.D_24.r,
                              ),
                            ),

                            SizedBox(height: DimensionsResources.D_20.h),

                            /// OMNIGO LOGO / IMAGE
                            Center(
                              child: Image.asset(
                                ImageResource.OMINGO_LOCATION_LOGO_IMG,
                                height: 200.h,
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(height: DimensionsResources.D_20.h),

                            /// HEADER TITLE
                            Center(
                              child: Text(
                                StringResources.selectYourLocation,
                                style: textTheme.displayMedium?.copyWith(
                                  fontSize: DimensionsResources.FONT_SIZE_EXTRA_LARGE.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.black,
                                ),
                              ),
                            ),

                            SizedBox(height: DimensionsResources.D_10.h),

                            Text(
                              StringResources.locationScreenSubtitle,
                              textAlign: TextAlign.center,
                              style: textTheme.bodyMedium?.copyWith(
                                fontSize: DimensionsResources.FONT_SIZE_SMALL.sp,
                                color: AppColors.lightText,
                              ),
                            ),

                            SizedBox(height: DimensionsResources.D_30.h),

                            /// ZONE DROPDOWN
                            DropdownButtonFormField<String>(
                              value: state.selectedZone,
                              key: ValueKey('zone_${state.selectedZone}'),
                              style: textTheme.bodyMedium?.copyWith(fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp),
                              decoration: const InputDecoration(
                                labelText: StringResources.yourZone,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary),
                                ),
                              ),
                              items: state.availableZones.toSet().map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) _bloc.add(ChangeZoneEvent(v));
                              },
                            ),

                            SizedBox(height: DimensionsResources.D_20.h),

                            DropdownButtonFormField<String>(
                              value: state.selectedArea,
                              key: ValueKey('area_${state.selectedArea}'),
                              style: textTheme.bodyMedium?.copyWith(fontSize: DimensionsResources.FONT_SIZE_MEDIUM.sp),
                              decoration: const InputDecoration(
                                labelText: StringResources.yourArea,
                                border: OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: AppColors.primary),
                                ),
                              ),
                              items: state.availableAreas.toSet().map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                );
                              }).toList(),
                              onChanged: (v) {
                                if (v != null) _bloc.add(ChangeAreaEvent(v));
                              },
                            ),
                            SizedBox(height: DimensionsResources.D_20.h),

                            AuthTextField(
                              label: StringResources.address,
                              hint: (state.detectedAddress != null && state.detectedAddress!.isNotEmpty)
                                  ? state.detectedAddress!
                                  : "Enter full Address",
                              controller: _addressController,
                              keyboardType: TextInputType.streetAddress,
                            ),
                            SizedBox(height: DimensionsResources.D_30.h),

                            /// SUBMIT ACTION BUTTON
                            AuthButton(
                              text: StringResources.submit,
                                onTap: () {

                                  if (state.selectedZone == null ||
                                      state.selectedArea == null ||
                                      _addressController.text.trim().isEmpty) {

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Please fill all fields"),
                                      ),
                                    );

                                    return;
                                  }

                                  _bloc.add(
                                    SubmitManualLocationEvent(
                                      zone: state.selectedZone!,
                                      area: state.selectedArea!,
                                      address: _addressController.text.trim(),
                                    ),
                                  );
                                }
                            ),
                            SizedBox(height: DimensionsResources.D_20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// BLURRED FULL SCREEN INTERCEPTOR LOADER
                if (state.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}