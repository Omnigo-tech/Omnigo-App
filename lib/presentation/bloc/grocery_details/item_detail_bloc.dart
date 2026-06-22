import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/data/models/order_model.dart';
import '../../../data/datasource/repositories/cart_repository.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import '../../../data/datasource/repositories/wishlist_repository.dart';
import '../../../data/models/grocery-item.dart';
import 'package:uuid/uuid.dart';
import 'item_detail_event.dart';
import 'item_detail_state.dart';

class GroceryDetailBloc extends Bloc<GroceryDetailEvent, GroceryDetailState> {
  final WishlistRepository wishlistRepository;
  final GroceryRepository groceryRepository;
  final CartRepository cartRepository;


  GroceryDetailBloc(this.wishlistRepository,this.groceryRepository,this.cartRepository) : super(GroceryDetailState(items: [], cart: [])) {

    on<LoadItemsEvent>((event, emit) async {
      try {
        final products = await groceryRepository.getProducts();
        final items = products.map((product) {
          return GroceryItemModel(
            id: product.id,
            name: product.name,
            image: product.image ?? "",
            price: product.price.toDouble(),
            description: product.description ?? "",
            weight: product.weight ?? "",
          );
        }).toList();

        emit(
          state.copyWith(
            items: items,
          ),
        );
      } catch (e) {
        print("Products Error: $e");
      }
    });

    on<ToggleFavoriteEvent>((event, emit) async {
      try {
        emit(state.copyWith(message: ""));
        final response =
        await wishlistRepository.toggleWishlist(event.id);

        final updated = state.items.map((item) {
          if (item.id == event.id) {
            return item.copyWith(
              isFavorite: response.isFavorite,

            );
          }
          return item;
        }).toList();

        emit(state.copyWith(
          items: updated,
          message: response.message,
        ));
      } catch (e) {
        emit(state.copyWith(message: "Something went wrong"));
      }
    });

    on<LoadFavoritesEvent>((event, emit) async {
      try {
        emit(state.copyWith(message: ""));
        final favorites = await wishlistRepository.getFavorites();

        emit(
          state.copyWith(
            favorites: favorites,
            isFavoritesLoading: false,
          ),
        );
      } catch (e) {
        print(e);
      }
    });

    on<IncrementQtyEvent>((event, emit) async {
      try {
        int currentQty = 0;
        final bool isInCart = state.cart.any((e) => e.id == event.id);

        if (isInCart) {
          final cartItem = state.cart.firstWhere((e) => e.id == event.id);
          currentQty = cartItem.quantity;
        } else {
          // 2. Agar cart mein nahi hai, to products list mein dhoonden
          final bool isInItems = state.items.any((e) => e.id == event.id);
          if (isInItems) {
            final item = state.items.firstWhere((e) => e.id == event.id);
            currentQty = item.quantity; // Default quantity or current selected quantity
          }
        }

        // Agar quantity zero hai ya initialization issue hai, to default 1 se start karein
        if (currentQty <= 0) currentQty = 1;

        // 3. Live API hit karein
        final response = await cartRepository.updateCart(
          productId: event.id,
          quantity: currentQty + 1,
        );

        // 4. State update karein
        emit(
          state.copyWith(
            cart: response.cartItems,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            message: e.toString(),
          ),
        );
      }
    });

    on<DecrementQtyEvent>((event, emit) async {
      try {
        int currentQty = 0;
        final bool isInCart = state.cart.any((e) => e.id == event.id);

        if (isInCart) {
          final cartItem = state.cart.firstWhere((e) => e.id == event.id);
          currentQty = cartItem.quantity;
        } else {
          final bool isInItems = state.items.any((e) => e.id == event.id);
          if (isInItems) {
            final item = state.items.firstWhere((e) => e.id == event.id);
            currentQty = item.quantity;
          }
        }

        // Agar item ki quantity 1 ya usse kam hai to decrement nahi chalna chahiye
        if (currentQty <= 1) return;

        final response = await cartRepository.updateCart(
          productId: event.id,
          quantity: currentQty - 1,
        );

        emit(
          state.copyWith(
            cart: response.cartItems,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            message: e.toString(),
          ),
        );
      }
    });



    on<RemoveFavoriteEvent>((event, emit) async {
      final originalFavorites = List<GroceryItemModel>.from(state.favorites);
      final updatedFavorites = state.favorites
          .where((item) => item.id != event.productId)
          .toList();

      final updatedItems = state.items.map((item) {
        if (item.id == event.productId) {
          return item.copyWith(isFavorite: false);
        }
        return item;
      }).toList();

      emit(state.copyWith(
          favorites: updatedFavorites,
          items: updatedItems,
          message: ""));

      try {
        final response = await wishlistRepository.removeFavorite(event.productId);
        if (response.success) {
          emit(
            state.copyWith(
              favorites: updatedFavorites,
              message: response.message,
            ),
          );
        } else {
          emit(
            state.copyWith(
              favorites: originalFavorites,
              message: "Failed to remove item",
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            favorites: originalFavorites,
            message: e.toString(),
          ),
        );
      }
    });

    // Purane local logic ko is async handler se replace karein
    on<RemoveFromCartEvent>((event, emit) async {
      try {
        // UI messaging clear karein
        emit(state.copyWith(message: ""));

        // Live API call: event.id pass ho raha hai jo hamari productId hai
        final response = await cartRepository.removeToCart(event.id);

        if (response.success) {
          emit(state.copyWith(
            cart: response.cartItems,
            message: response.message, // "Item removed"
          ));
          print("Remove From Cart");
        } else {
          emit(state.copyWith(message: "Failed to remove item from server"));
        }
      } catch (e) {
        emit(state.copyWith(message: e.toString()));
        print("Remove From Cart Error: $e");
      }
    });

    on<GetCartItemsEvent>((event, emit) async {
      try {
        emit(state.copyWith(message: ""));

        final response = await cartRepository.getCartItems();

        if (response.success) {
          emit(
            state.copyWith(
              cart: response.cartItems,
            ),
          );
        }
      } catch (e) {
        emit(
          state.copyWith(
            message: e.toString(),
          ),
        );
      }
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        final isAlreadyInCart = state.cart.any((cartItem) => cartItem.id == event.item.id);

        if (isAlreadyInCart) {
          // Pehle state clear emit karein taake BlocListener har bar properly catch kare
          emit(state.copyWith(message: ""));

          emit(state.copyWith(
            message: "This item is already in your cart!",
          ));
          return;
        }

        emit(state.copyWith(message: ""));

        final response = await cartRepository.addToCart(
          event.item.id,
          event.item.quantity,
        );

        if (response.success) {
          emit(state.copyWith(
            cart: response.cartItems,
            message: response.message ?? "Success", // Ensure message blank na ho
          ));
        } else {
          emit(state.copyWith(message: "Failed to add item"));
        }
      } catch (e) {
        emit(state.copyWith(message: e.toString()));
        print("Add to Cart Error: $e");
      }
    });



    on<PlaceOrderEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isOrderLoading: true,
            message: "",
          ),
        );

        final response = await cartRepository.placeOrder(
          addressId: event.address.id,
          paymentMethod: event.paymentMethod,
        );

        emit(
          state.copyWith(
            isOrderLoading: false,
            cart: [],
            message: response.message,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            isOrderLoading: false,
            message: e.toString(),
          ),
        );
      }
    });

    on<GetMyOrdersEvent>((event, emit) async {
      try {
        emit(state.copyWith(isOrderLoading: true, message: ""));
        final response = await cartRepository.getMyOrders();

        if (response.success) {
          emit(state.copyWith(
            orders: response.orders,
            isOrderLoading: false,
          ));
        } else {
          emit(state.copyWith(
            isOrderLoading: false,
            message: "Failed to load orders",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isOrderLoading: false,
          message: e.toString(),
        ));
        print("Get Orders Error: $e");
      }
    });

    on<CancelOrderEvent>((event, emit) async {
      try {
        emit(state.copyWith(isOrderLoading: true, message: ""));
        final response = await cartRepository.cancelOrder(event.orderId);

        if (response.success) {
          add(GetMyOrdersEvent());
        } else {
          emit(state.copyWith(
            isOrderLoading: false,
            message: "Failed to cancel order from server",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isOrderLoading: false,
          message: e.toString(),
        ));
        print("Cancel Order Error: $e");
      }
    });


    on<GetOrderDetailsEvent> ((event, emit) async {
      emit(state.copyWith(isOrderDetailLoading: true, message: ''));
      try {
        final response = await cartRepository.getOrderDetails(event.orderId);
        if (response.success && response.order != null) {
          emit(state.copyWith(
            isOrderDetailLoading: false,
            orderDetail: response.order,
          ));
        } else {
          emit(state.copyWith(isOrderDetailLoading: false, message: "Failed to load order"));
        }
      } catch (e) {
        emit(state.copyWith(isOrderDetailLoading: false, message: e.toString()));
      }
    });

    // GroceryDetailBloc ke andar:

    on<CallReorderApiEvent>((event, emit) async {
      try {
        emit(state.copyWith(isOrderLoading: true, message: ""));

        final response = await cartRepository.reorderOrder(event.orderId);

        if (response.success && response.orders != null) {
          emit(state.copyWith(
            isOrderLoading: false,
            orders: response.orders,
            message: "Reorder Success",
          ));
        } else {
          emit(state.copyWith(
            isOrderLoading: false,
            message: "Failed to reorder",
          ));
        }
      } catch (e) {
        emit(state.copyWith(
          isOrderLoading: false,
          message: e.toString(),
        ));
      }
    });
  }


}
