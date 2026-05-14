import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';
import 'package:grocery_app/presentation/screens/user_interface/address_list/add_address_screen.dart';
import 'package:grocery_app/widgets/app_bar_widget.dart';

import '../../../../core/helper/constants/strings-resource.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: StringResources.addressDetail,
        showBackButton: true,
      ),

      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return SafeArea(
            child: ListView.builder(
              itemCount: state.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index != state.addresses.length) {
                  final item = state.addresses[index];
                  print("item is ${item}");
                  return GestureDetector(
                    onTap: () {
                      context.read<AddressBloc>().add(SelectAddressEvent(item));
                      Navigator.pop(context);
                    },
                    child: ListTile(
                  title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.locationname,
                          style: const TextStyle(fontWeight: FontWeight.bold)),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<AddressBloc>(),
                                    child: AddAddressScreen(
                                      index: index,
                                      existingAddress: item,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<AddressBloc>().add(
                                DeleteAddressEvent(index),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const Divider(),
                Text(item.username),
                Text(item.phone),
                Text(item.address),
                ],
                ),
                ),
                  );
                } else {
                  return Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<AddressBloc>(),
                              child: const AddAddressScreen(),
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(height: DimensionsResources.D_36.h),
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: AppColors.border,
                            child: Icon(Icons.add, color: AppColors.white),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            "Add new address",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
