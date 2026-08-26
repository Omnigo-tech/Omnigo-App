import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasource/repositories/cart_repository.dart';
import '../../../data/datasource/repositories/glocery_data.dart';
import '../../../data/datasource/repositories/wishlist_repository.dart';
import '../../../data/models/grocery-item.dart';
import 'item_detail_event.dart';
import 'item_detail_state.dart';
import 'dart:async';
import 'grocery_ui_effect.dart';

class GroceryDetailBloc extends Bloc<GroceryDetailEvent, GroceryDetailState> {
  final WishlistRepository wishlistRepository;
  final GroceryRepository groceryRepository;
  final CartRepository cartRepository;
  final _effectController = StreamController<GroceryUiEffect>.broadcast();
  Stream<GroceryUiEffect> get effectStream => _effectController.stream;

  void _showSnackbar(String message) {
    _effectController.add(
      ShowSnackbarEffect(message),
    );
  }
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
        final response = await wishlistRepository.toggleWishlist(event.id);

        final updated = state.items.map((item) {
          if (item.id == event.id) {
            return item.copyWith(
              isFavorite: response.isFavorite,
            );
          }
          return item;
        }).toList();

        emit(
          state.copyWith(
            items: updated,
          ),
        );
        _showSnackbar(response.message);
      } catch (e) {
        _showSnackbar("Something went wrong");
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

        final isInCart = state.cart.any((e) => e.id == event.id);

        if (isInCart) {
          currentQty = state.cart.firstWhere((e) => e.id == event.id).quantity;
        } else {
          final item = state.items.firstWhere((e) => e.id == event.id);
          currentQty = item.quantity;
        }

        if (currentQty <= 0) currentQty = 1;

        final response = await cartRepository.updateCart(
          productId: event.id,
          quantity: currentQty + 1,
        );

        emit(
          state.copyWith(
            cart: response.cartItems,
          ),
        );
      } catch (e) {
        _showSnackbar(e.toString());
      }
    });

    on<DecrementQtyEvent>((event, emit) async {
      try {
        int currentQty = 0;

        final isInCart = state.cart.any((e) => e.id == event.id);

        if (isInCart) {
          currentQty = state.cart.firstWhere((e) => e.id == event.id).quantity;
        } else {
          final item = state.items.firstWhere((e) => e.id == event.id);
          currentQty = item.quantity;
        }

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
        _showSnackbar(e.toString());
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

      emit(
        state.copyWith(
          favorites: updatedFavorites,
          items: updatedItems,
        ),
      );

      try {
        final response = await wishlistRepository.removeFavorite(event.productId);
        if (response.success) {
          emit(
            state.copyWith(
              favorites: updatedFavorites,
            ),
          );

          _showSnackbar(response.message);
        } else {
          emit(
            state.copyWith(
              favorites: originalFavorites,
            ),
          );

          _showSnackbar("Failed to remove item");
        }
      }catch (e) {
        emit(
          state.copyWith(
            favorites: originalFavorites,
          ),
        );
        _showSnackbar(e.toString());
      }
    });

    // Purane local logic ko is async handler se replace karein
    on<RemoveFromCartEvent>((event, emit) async {
      try {
        final response = await cartRepository.removeToCart(event.id);

        if (response.success) {
          emit(
            state.copyWith(
              cart: response.cartItems,
            ),
          );

          _showSnackbar(response.message);
        } else {
          _showSnackbar("Failed to remove item from server");
        }
      } catch (e) {
        _showSnackbar(e.toString());
        print("Remove From Cart Error: $e");
      }
    });

    on<GetCartItemsEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            cartLoading: true,
          ),
        );

        final response = await cartRepository.getCartItems();

        if (response.success) {
          emit(
            state.copyWith(
              cart: response.cartItems,
              cartLoading: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              cartLoading: false,
            ),
          );

          _showSnackbar("Failed to load cart");
        }
      } catch (e) {
        emit(
          state.copyWith(
            cartLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });

    on<AddToCartEvent>((event, emit) async {
      try {
        final isAlreadyInCart = state.cart.any((cartItem) => cartItem.id == event.item.id);

        if (isAlreadyInCart) {
          _showSnackbar("This item is already in your cart!");
          return;
        }

        final response = await cartRepository.addToCart(
          event.item.id,
          event.item.quantity,
        );

        if (response.success) {
          emit(
            state.copyWith(
              cart: response.cartItems,
            ),
          );
          _effectController.add(
            ShowAddedToCartDialogEffect(
              items:[event.item],
            ),
          );
        } else {
          _showSnackbar("Failed to add item");
        } }
      catch (e) {
        _showSnackbar(e.toString());
      }
    });

    on<BulkAddToCartEvent>((event, emit) async {
      try {

        final response = await cartRepository.bulkAddToCart(
          event.items,
        );

        if (response.success) {

          emit(
            state.copyWith(
              cart: response.cartItems,
            ),
          );

          _effectController.add(
            ShowAddedToCartDialogEffect(
              items: event.items,
            ),
          );

        } else {

          _showSnackbar(response.message);

        }

      } catch (e) {

        _showSnackbar(e.toString());

      }
    });


    on<PlaceOrderEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isOrderLoading: true,
          ),
        );

        final response = await cartRepository.placeOrder(
          addressId: event.id,
          paymentMethod: event.paymentMethod,
        );

        emit(
          state.copyWith(
            isOrderLoading: false,
            cart: [],
            orderId: response.orderId,
          ),
        );

        _effectController.add(
          OrderPlacedEffect(response.orderId),
        );
        _showSnackbar(response.message);

      } catch (e) {
        emit(
          state.copyWith(
            isOrderLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });

    on<GetMyOrdersEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isOrderLoading: true,
          ),
        );

        final response = await cartRepository.getMyOrders();

        if (response.success) {
          emit(
            state.copyWith(
              orders: response.orders,
              isOrderLoading: false,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isOrderLoading: false,
            ),
          );

          _showSnackbar("Failed to load orders");
        }
      } catch (e) {
        emit(
          state.copyWith(
            isOrderLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });

    on<CancelOrderEvent>((event, emit) async {
      try {
        emit(state.copyWith(isOrderLoading: true));
        final response = await cartRepository.cancelOrder(event.orderId);

        if (response.success) {
          add(GetMyOrdersEvent());
        } else {
          emit(state.copyWith(
            isOrderLoading: false,
          ));
          _showSnackbar("Failed to cancel order");
        }
      } catch (e) {
        emit(
          state.copyWith(
            isOrderLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });


    on<GetOrderDetailsEvent>((event, emit) async {
      emit(
        state.copyWith(
          isOrderDetailLoading: true,
        ),
      );

      try {
        final response = await cartRepository.getOrderDetails(event.orderId);

        if (response.success && response.order != null) {
          emit(
            state.copyWith(
              isOrderDetailLoading: false,
              orderDetail: response.order,
            ),
          );
        } else {
          emit(
            state.copyWith(
              isOrderDetailLoading: false,
            ),
          );

          _showSnackbar("Failed to load order");
        }
      } catch (e) {
        emit(
          state.copyWith(
            isOrderDetailLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });

    // GroceryDetailBloc ke andar:

    on<CallReorderApiEvent>((event, emit) async {
      try {
        emit(
          state.copyWith(
            isOrderLoading: true,
          ),
        );

        final response = await cartRepository.reorderOrder(event.orderId);

        if (response.success && response.orders != null) {
          emit(
            state.copyWith(
              isOrderLoading: false,
              orders: response.orders,
            ),
          );

          _showSnackbar("Reorder Success");
        } else {
          emit(
            state.copyWith(
              isOrderLoading: false,
            ),
          );

          _showSnackbar("Failed to reorder");
        }
      } catch (e) {
        emit(
          state.copyWith(
            isOrderLoading: false,
          ),
        );

        _showSnackbar(e.toString());
      }
    });
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }

}
