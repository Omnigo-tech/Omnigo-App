import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/presentation/bloc/address/address_bloc.dart';
import 'package:grocery_app/presentation/bloc/address/address_event.dart';
import 'package:grocery_app/presentation/bloc/address/address_state.dart';

class AddressListScreen extends StatelessWidget {
  const AddressListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Address Detail"),
        toolbarHeight: DimensionsResources.D_100,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new),
        ),
      ),

      body: BlocBuilder<AddressBloc, AddressState>(
        builder: (context, state) {
          return SafeArea(
            child: ListView.builder(
              itemCount: state.addresses.length + 1,
              itemBuilder: (context, index) {
                if (index != state.addresses.length) {
                  final item = state.addresses[index];
                  return GestureDetector(
                    onTap: () {
                      context.read<AddressBloc>().add(SelectAddressEvent(item));
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.locationname,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.edit),
                            color: AppColors.lightText,
                          ),
                        ],
                      ), //Text(item.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(thickness: 1),
                          SizedBox(height: DimensionsResources.D_10),
                          Text(
                            item.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(height: DimensionsResources.D_10),
                          Text(item.phone),
                          SizedBox(height: DimensionsResources.D_10),
                          Text(item.address),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: GestureDetector(
                      onTap: () {},
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
