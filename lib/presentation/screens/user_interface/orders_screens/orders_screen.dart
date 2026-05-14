import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grocery_app/core/helper/constants/colors_resources.dart';
import 'package:grocery_app/core/helper/constants/dimensions-resource.dart';
import 'package:grocery_app/core/helper/constants/strings-resource.dart';
import 'package:grocery_app/core/routes/AppRoutes.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_event.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'package:grocery_app/presentation/bloc/grocery_details/item_detail_state.dart';
import 'package:intl/intl.dart';
import 'order_detail_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "delivered":
        return Colors.green;
      case "cancelled":
        return AppColors.red;
      default:
        return AppColors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text("Orders"),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: StringResources.ongoing),
            Tab(text: StringResources.history),
          ],
        ),
      ),
      body: BlocBuilder<GroceryDetailBloc, GroceryDetailState>(
        builder: (context, state) {
          final ongoing = state.orders
              .where((o) => o.status == "pending")
              .toList();

          final history = state.orders
              .where((o) => o.status != "pending")
              .toList();
          return TabBarView(
            controller: _tabController,
            children: [_buildOngoingList(ongoing), _buildHistoryList(history)],
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(List orders) {
    if (orders.isEmpty) {
      return const Center(child: Text(StringResources.noOrders));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(DimensionsResources.D_16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final order = orders[index];

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 22.r,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.shopping_bag, color: AppColors.white),
          ),
          title: Text(
            "Order #${order.id}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.status,
                style: TextStyle(color: getStatusColor(order.status)),
              ),
              Text(
                DateFormat.yMMMMd().format(order.date),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          trailing: Text(
            order.total.toStringAsFixed(0),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: DimensionsResources.D_16,
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrderDetailScreen(order: order),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOngoingList(List orders) {
    if (orders.isEmpty) {
      return const Center(child: Text(StringResources.noOngoingOrders));
    }

    return ListView.builder(
      padding: EdgeInsets.all(DimensionsResources.D_16.h),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];

        double subtotal = 0;

        for (var item in order.items) {
          subtotal += item.price * item.quantity;
        }

        final deliveryFee = 200.0;
        final total = subtotal + deliveryFee;

        return Container(
          margin: EdgeInsets.only(bottom: DimensionsResources.D_20.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(DimensionsResources.D_14.r),
            border: Border.all(color: const Color(0xffB9D7FF), width: 1.5.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8.r,
                offset: Offset(
                  DimensionsResources.D_0,
                  DimensionsResources.D_3,
                ),
              ),
            ],
          ),

          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),

            child: ExpansionTile(
              initiallyExpanded: true,

              tilePadding: EdgeInsets.symmetric(
                horizontal: DimensionsResources.D_18.h,
                vertical: DimensionsResources.D_4,
              ),

              childrenPadding: EdgeInsets.only(
                left: DimensionsResources.D_18.w,
                right: DimensionsResources.D_18.w,
                bottom: DimensionsResources.D_18.h,
              ),

              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    StringResources.itemsOrdered,
                    style: TextStyle(
                      fontSize: DimensionsResources.FONT_SIZE_SMALL,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Text(
                    "${order.items.length} items",
                    style: const TextStyle(
                      color: AppColors.homeBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: DimensionsResources.FONT_SIZE_SMALL,
                    ),
                  ),
                ],
              ),

              children: [
                /// ITEMS
                Column(
                  children: order.items.map<Widget>((item) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: DimensionsResources.D_10,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: DimensionsResources.D_6.w,
                            height: DimensionsResources.D_6.h,
                            decoration: const BoxDecoration(
                              color: Color(0xffB9D7FF),
                              shape: BoxShape.circle,
                            ),
                          ),

                          SizedBox(width: DimensionsResources.D_10.w),

                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: DimensionsResources
                                    .FONT_SIZE_1X_EXTRA_SMALL,
                              ),
                            ),
                          ),

                          Text(
                            "x${item.quantity}",
                            style: const TextStyle(
                              fontSize: DimensionsResources.FONT_SIZE_SMALL,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const Divider(),

                /// SUBTOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      StringResources.subTotal,
                      style: TextStyle(color: AppColors.grey),
                    ),

                    Text(subtotal.toStringAsFixed(0)),
                  ],
                ),

                const SizedBox(height: 8),

                /// DELIVERY
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      StringResources.deliveryFee,
                      style: TextStyle(color: AppColors.grey),
                    ),

                    Text(
                      "Rs.${deliveryFee.toStringAsFixed(0)}",
                      style: const TextStyle(color: AppColors.grey),
                    ),
                  ],
                ),
                const Divider(),

                /// TOTAL
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      StringResources.total,
                      style: TextStyle(
                        fontSize: DimensionsResources.FONT_SIZE_MEDIUM,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "Rs:${total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: DimensionsResources.FONT_SIZE_MEDIUM,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homeBackground,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: DimensionsResources.D_15.h),

                /// SUPPORT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.support_agent, size: DimensionsResources.D_18),

                    SizedBox(width: DimensionsResources.D_5.w),

                    Text(
                      "NEED HELP?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: DimensionsResources.FONT_SIZE_2X_EXTRA_SMALL,
                      ),
                    ),

                    SizedBox(width: DimensionsResources.D_5.w),

                    Text(
                      "Contact Support",
                      style: TextStyle(
                        color: AppColors.homeBackground,
                        fontSize: DimensionsResources.FONT_SIZE_2X_EXTRA_SMALL,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: DimensionsResources.D_24.h),

                /// BUTTONS
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: DimensionsResources.D_52.h,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.homeBackground,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                DimensionsResources.D_14.r,
                              ),
                            ),
                          ),

                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.trackingOrder);
                          },

                          icon: const Icon(
                            Icons.location_on,
                            color: AppColors.white,
                          ),

                          label: Text(
                            StringResources.trackLive,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: DimensionsResources.FONT_SIZE_SMALL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: DimensionsResources.D_16.w),

                    Expanded(
                      child: SizedBox(
                        height: DimensionsResources.D_52.h,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.homeBackground,
                              width: 2.w,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),

                          onPressed: () {
                            context.read<GroceryDetailBloc>().add(
                              CancelOrderEvent(order.id),
                            );
                          },

                          child: const Text(
                            StringResources.cancelOrder,
                            style: TextStyle(
                              color: AppColors.homeBackground,
                              fontSize:
                                  DimensionsResources.FONT_SIZE_1X_EXTRA_SMALL,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
