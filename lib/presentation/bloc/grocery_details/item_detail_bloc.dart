import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import '../../../data/models/grocery-item.dart';
import 'item_detail_event.dart';
import 'item_detail_state.dart';


class GroceryDetailBloc extends Bloc<GroceryDetailEvent, GroceryDetailState> {
  GroceryDetailBloc()
      : super(GroceryDetailState(items: [], cart: [])) {

    on<LoadItemsEvent>((event, emit) {
      final items = GroceryData.getGroceryList().map((item) => GroceryItemModel(
        id: item.id,
        name: item.name,
        image: item.image,
        price: item.price,
        description: item.description ?? "",
        weight: item.weight ?? "",
      )).toList();
      
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

      final existingIndex =
      updatedCart.indexWhere((e) => e.id == event.item.id);

      if (existingIndex >= 0) {
        updatedCart[existingIndex] = event.item;
      } else {
        updatedCart.add(event.item);
      }

      emit(state.copyWith(cart: updatedCart));
    });

    on<RemoveFromCartEvent>((event, emit) {
      final updatedCart = state.cart.where((item) => item.id != event.id).toList();
      emit(state.copyWith(cart: updatedCart));
    });

    on<PlaceOrderEvent>((event, emit) {
      emit(state.copyWith(cart: []));
    });
  }
}
