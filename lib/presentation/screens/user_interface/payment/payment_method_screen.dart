import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/images-resources.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';
import '../../../../core/helper/extension/payment_extention.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/cutom_button.dart';
import '../../../bloc/payment/payment_bloc.dart';
import '../../../bloc/payment/payment_event.dart';
import '../../../bloc/payment/payment_state.dart';

class PaymentMethodScreen extends StatelessWidget {
   PaymentMethodScreen({super.key});
  final methods = [
    {'icon': Icons.money, 'label': StringResources.cashDelivery},
    {'icon': Icons.account_balance_wallet, 'label': StringResources.mobileWallet},
    {'icon': Icons.credit_card, 'label': StringResources.creditDebitCard},
    {'icon': Icons.account_balance, 'label': StringResources.bankAccount},
  ];
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: StringResources.paymentMethod,
      ),
      body: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(context),

                SizedBox(height: DimensionsResources.D_30.h),

                _buildMethodTabs(context, state),

                SizedBox(height: DimensionsResources.D_20.h),

                Expanded(
                  child: SingleChildScrollView(
                    child: _buildPaymentContent(context, state),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(DimensionsResources.D_20.w),
                  child: CustomButton(
                    text: StringResources.payNow,
                    textColor: AppColors.white,
                      onClick: () {
                        final stateBloc = context.read<PaymentBloc>().state;
                        if (stateBloc.selectedIndex == 1 && stateBloc.walletIndex == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(StringResources.snackbarErrorWallet)),
                          );
                          return;
                        }

                        if (stateBloc.selectedIndex == 3 && stateBloc.bankIndex == -1) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(StringResources.snackbarErrorBank)),
                          );
                          return;
                        }
                        if (formKey.currentState!.validate()) {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.addressdetail,
                            arguments: methods[state.selectedIndex]['label'],
                          );
                        }
                      }
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= STEP INDICATOR =================
  Widget _buildStepIndicator(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: DimensionsResources.D_20.h,
        left: DimensionsResources.D_30.w,
        right: DimensionsResources.D_30.w,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: DimensionsResources.D_14.r,
                backgroundColor: AppColors.grey,
              ),
              Expanded(
                child: Container(
                  height: DimensionsResources.D_2.h,
                  color: AppColors.border,
                ),
              ),
              Container(
                width: DimensionsResources.D_28.r,
                height: DimensionsResources.D_28.r,
                padding: EdgeInsets.all(DimensionsResources.D_3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBlue,
                    width: DimensionsResources.D_2,
                  ),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: DimensionsResources.D_8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringResources.shippingAddress,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.grey,
                  fontSize: DimensionsResources.D_14.w,
                ),
              ),
              Text(
                StringResources.paymentMethod,
                style:Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.black,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= METHOD TABS =================
  Widget _buildMethodTabs(BuildContext context, PaymentState state) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(methods.length, (index) {
          bool isSelected = state.selectedIndex == index;

          return Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? DimensionsResources.D_10.w : DimensionsResources.D_0_4.w,
              right: DimensionsResources.D_10.w,
            ),
            child: GestureDetector(
              onTap: () =>
                  context.read<PaymentBloc>().add(ChangeCardIndex(index)),
              child: Container(
                width: DimensionsResources.D_100.w,
                height: DimensionsResources.D_60.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(
                    DimensionsResources.D_20.r,
                  ),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      methods[index]['icon'] as IconData,
                      size: DimensionsResources.D_18.sp,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.grey,
                    ),
                    SizedBox(height: DimensionsResources.D_4.h),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: DimensionsResources.D_6.w,
                      ),
                      child: Text(
                        methods[index]['label'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ================= CONTENT SWITCH =================
  Widget _buildPaymentContent(BuildContext context, PaymentState state) {
    switch (state.selectedIndex) {
      case 0:
        return Padding(
          padding: EdgeInsets.all(DimensionsResources.D_20.w),
          child: Center(child: Text(StringResources.cashOnDelivery)),
        );

      case 1:
        return _buildWalletForm(context, state);

      case 2:
        return _buildCreditCardForm(context, state);

      case 3:
        return _buildBankForm(context, state);

      default:
        return const SizedBox.shrink();
    }
  }

  // ================= CREDIT CARD =================
  Widget _buildCreditCardForm(BuildContext context, PaymentState state) {
    return Column(
      children: [
        _buildVisualCard(state),
        PaymentInputField(
          hint: StringResources.cardHolder,
          validator: (v) => v?.validateHolder(),
          onChanged: (v) =>
              context.read<PaymentBloc>().add(UpdateHolder(v)),
        ),

        PaymentInputField(
          hint: StringResources.cardNumber,
          validator: (v) => v?.validateCardNumber(),
          onChanged: (v) =>
              context.read<PaymentBloc>().add(UpdateCardNumber(v)),
        ),

        Row(
          children: [
            Expanded(
              child:PaymentInputField(
                hint: StringResources.expiryDate,
                validator: (v) => v?.validateExpiry(),
                onChanged: (v) =>
                    context.read<PaymentBloc>().add(UpdateExpiry(v)),
              ),
            ),
            Expanded(
              child: PaymentInputField(
                hint: StringResources.cvv,
                validator: (v) => v?.validateCvv(),
                isObscure: !state.showCvv,
                onChanged: (v) =>
                    context.read<PaymentBloc>().add(UpdateCvv(v)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= WALLET =================
  Widget _buildWalletForm(BuildContext context, PaymentState state) {
    final wallets = [
      {'name': StringResources.easyPaisa, 'icon': ImageResource.EASY_PAISA_LOGO},
      {'name': StringResources.jazzCash, 'icon': ImageResource.JaAZZ_CASH_LOGO},
      {'name': StringResources.upaisa, 'icon': ImageResource.UPAISA_LOGO},
      {'name': StringResources.zindghi, 'icon': ImageResource.ZINDGHI_LOGO},
    ];

    return Column(
      children: [
        _buildDropdown(
          context: context,
          hint: StringResources.selectWallet,
          items: wallets,
          selectedIndex: state.walletIndex,
          onChanged: (index) =>
              context.read<PaymentBloc>().add(ChangeWalletIndex(index)),
        ),

        PaymentInputField(
          hint: StringResources.mobileNumber,
          validator: (v) => v?.validateMobile(),
          onChanged: (v) =>
              context.read<PaymentBloc>().add(UpdatePhoneNumber(v)),
        ),
      ],
    );
  }

  // ================= BANK =================
  Widget _buildBankForm(BuildContext context, PaymentState state) {
    final banks = [
      {'name': StringResources.mezanBank, 'icon': ImageResource.MEZAN_BANK},
      {'name': StringResources.hbl, 'icon': ImageResource.HBL_BANK},
      {'name': StringResources.bankAlfalah, 'icon': ImageResource.ALFALAH_BANK},
    ];

    return Column(
      children: [
        _buildDropdown(
          context: context,
          hint: StringResources.selectBank,
          items: banks,
          selectedIndex: state.bankIndex,
          onChanged: (index) =>
              context.read<PaymentBloc>().add(ChangeBankIndex(index)),
        ),

        PaymentInputField(
          hint: StringResources.iban,
          validator: (v) => v?.validateIban(),
          onChanged: (v) {},
        ),

        PaymentInputField(
          hint: StringResources.cnic,
          validator: (v) => v?.validateCNIC(),
          onChanged: (v) {},
        ),
      ],
    );
  }

  // ================= DROPDOWN =================
  Widget _buildDropdown({
    required BuildContext context,
    required String hint,
    required List<Map<String, String>> items,
    required int selectedIndex,
    required Function(int) onChanged,
  }) {
    final valueListenable = ValueNotifier<int?>(
      selectedIndex == -1 ? null : selectedIndex,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: DimensionsResources.D_20.w,
        vertical: DimensionsResources.D_8.h,
      ),
      child: DropdownButtonHideUnderline(

        child: DropdownButton2<int>(
          isExpanded: true,
          hint: Text(
            hint,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(
              color: AppColors.grey,
              fontSize:DimensionsResources.D_14.w,
            ),
          ),
          items: items.asMap().entries.map((entry) {
            int index = entry.key;
            var item = entry.value;

            return DropdownItem<int>(
              value: index,
              height: DimensionsResources.D_46.h,
              child: Row(
                children: [
                  Image.asset(
                    item["icon"] ?? "",
                    width: DimensionsResources.D_30.w,
                    height: DimensionsResources.D_25.h,
                  ),
                  SizedBox(width: DimensionsResources.D_10.w),
                  Text(
                    item["name"] ?? "",
                    style: TextStyle(
                      fontSize:
                      DimensionsResources.FONT_SIZE_SMALL.sp,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          valueListenable: valueListenable,
          onChanged: (value) {
            if (value != null) {
              valueListenable.value = value;
              onChanged(value);
            }
          },
          buttonStyleData: ButtonStyleData(
            padding: EdgeInsets.symmetric(
              horizontal: DimensionsResources.D_14.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(
                DimensionsResources.RADIUS_DEFAULT.r,
              ),
            ),
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: DimensionsResources.D_306.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                DimensionsResources.RADIUS_DEFAULT.r,
              ),
              color: AppColors.white,
            ),
            isOverButton: false,
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: EdgeInsets.symmetric(
              horizontal: DimensionsResources.D_14.w,
            ),
          ),
        ),
      ),
    );
  }

  // ================= CARD UI =================
  Widget _buildVisualCard(PaymentState state) {
    return Container(
      height: DimensionsResources.D_180.h,
      margin: EdgeInsets.all(DimensionsResources.D_20.w),
      padding: EdgeInsets.all(DimensionsResources.D_20.w),
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(DimensionsResources.RADIUS_LARGE.r),
        gradient: LinearGradient(
          colors: [
            AppColors.cardGoldGradientStart,
            AppColors.cardGoldGradientEnd
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(StringResources.creditCard,
              style: TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.bold,
              )),
          const Spacer(),
          Text(
            state.cardNumber.isEmpty
                ? "XXXX XXXX XXXX XXXX"
                : state.cardNumber,
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(state.holder.isEmpty
                  ? StringResources.cardHolderLabel
                  : state.holder),
              Text(state.expiry.isEmpty ? StringResources.expiryHint : state.expiry),
            ],
          )
        ],
      ),
    );
  }
}