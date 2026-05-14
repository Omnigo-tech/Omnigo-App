import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/data/models/order_model.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import '../../../data/models/grocery-item.dart';
import 'package:uuid/uuid.dart';
import 'item_detail_event.dart';
import 'item_detail_state.dart';

class GroceryDetailBloc extends Bloc<GroceryDetailEvent, GroceryDetailState> {
  GroceryDetailBloc() : super(GroceryDetailState(items: [], cart: [])) {
    on<LoadItemsEvent>((event, emit) {
      final items = GroceryData.getGroceryList()
          .map(
            (item) => GroceryItemModel(
              id: item.id,
              name: item.name,
              image: item.image,
              price: item.price,
              description: item.description ?? "",
              weight: item.weight ?? "",
            ),
          )
          .toList();

      emit(state.copyWith(items: items));
    });

    on<ToggleFavoriteEvent>((event, emit) {
      final updated = state.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(isFavorite: !item.isFavorite);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updated));
    });

    on<IncrementQtyEvent>((event, emit) {
      final updated = state.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      final updatedCart = state.cart.map((item) {
        if (item.id == event.id) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updated, cart: updatedCart));
    });

    on<DecrementQtyEvent>((event, emit) {
      final updated = state.items.map((item) {
        if (item.id == event.id && item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      final updatedCart = state.cart.map((item) {
        if (item.id == event.id && item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updated, cart: updatedCart));
    });

    on<AddToCartEvent>((event, emit) {
      final updatedCart = List<GroceryItemModel>.from(state.cart);

      final existingIndex = updatedCart.indexWhere(
        (e) => e.id == event.item.id,
      );

      if (existingIndex >= 0) {
        updatedCart[existingIndex] = event.item;
      } else {
        updatedCart.add(event.item);
      }

      emit(state.copyWith(cart: updatedCart));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updatedCart = state.cart
          .where((item) => item.id != event.id)
          .toList();
      emit(state.copyWith(cart: updatedCart));
    });

    on<PlaceOrderEvent>((event, emit) {
      final cartItems = state.cart;

      if (cartItems.isEmpty) return;

      double total = 0;
      for (var item in cartItems) {
        total += item.price * item.quantity;
      }

      final newOrder = OrderModel(
        id: Uuid().v4().substring(0, 6),
        items: List.from(cartItems),
        total: total,
        status: "pending",
        address: event.address,
        paymentMethod: event.paymentMethod,
        date: DateTime.now(),
      );

      final updatedOrders = List<OrderModel>.from(state.orders)..add(newOrder);

      emit(state.copyWith(cart: [], orders: updatedOrders));
    });

    on<CancelOrderEvent>((event, emit) {
      final updatedOrders = state.orders.map((order) {
        if (order.id == event.orderId) {
          return OrderModel(
            id: order.id,
            items: order.items,
            total: order.total,
            status: "cancelled",
            address: order.address,
            paymentMethod: order.paymentMethod,
            date: order.date,
          );
        }

        return order;
      }).toList();

      emit(state.copyWith(orders: updatedOrders));
    });

    on<ReorderItemsEvent>((event, emit) {
      emit(state.copyWith(cart: List.from(event.items)));
    });
  }
}
