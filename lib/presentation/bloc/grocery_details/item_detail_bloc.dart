import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/local/grocery_local_data_source.dart';
import '../../../data/models/grocery-item.dart';
import 'item_detail_event.dart';
import 'item_detail_state.dart';


class GroceryDetailBloc extends Bloc<GroceryDetailEvent, GroceryDetailState> {
  GroceryDetailBloc()
      : super(GroceryDetailState(items: [], cart: [])) {
    final GroceryLocalDataSource dataSource = GroceryLocalDataSource();

    on<LoadItemsEvent>((event, emit) {
      final items = dataSource.getGroceryItems();
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
      print("Incrementing ID: ${event.id}"); // Debugging
      final updated = state.items.map((item) {
        if (item.id == event.id) {
          return item.copyWith(quantity: item.quantity + 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updated));
    });

    on<DecrementQtyEvent>((event, emit) {
      final updated = state.items.map((item) {
        if (item.id == event.id && item.quantity > 1) {
          return item.copyWith(quantity: item.quantity - 1);
        }
        return item;
      }).toList();

      emit(state.copyWith(items: updated));
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
  }
}