import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helper/constants/colors_resources.dart';
import '../../../bloc/grocery_details/item_detail_bloc.dart';
import '../../../bloc/grocery_details/item_detail_state.dart';


class MyCartScreen extends StatelessWidget {
  const MyCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final cartList = state.cart;

          if (cartList.isEmpty) {
            return const Center(
              child: Text("Your cart is empty"),
            );
          }

          /// 🟢 CART ITEMS
          return ListView.builder(
            itemCount: cartList.length,
            itemBuilder: (context, index) {
              final item = cartList[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Image.asset(item.image, width: 50),
                  title: Text(item.name),
                  subtitle: Text("Qty: ${item.quantity}"),
                  trailing: Text(item.weight ?? ""),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
