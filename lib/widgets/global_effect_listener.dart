import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/helper/utils/dialogs/show_cart_dialog.dart';
import '../presentation/bloc/grocery_details/grocery_ui_effect.dart';
import '../presentation/bloc/grocery_details/item_detail_bloc.dart';
import 'custom_snackbar.dart';

class GlobalEffectListener extends StatefulWidget {
  final Widget child;

  const GlobalEffectListener({
    super.key,
    required this.child,
  });

  @override
  State<GlobalEffectListener> createState() =>
      _GlobalEffectListenerState();
}

class _GlobalEffectListenerState
    extends State<GlobalEffectListener> {

  StreamSubscription<GroceryUiEffect>? _subscription;

  @override
  void initState() {
    super.initState();

    final bloc = context.read<GroceryDetailBloc>();

    _subscription = bloc.effectStream.listen((effect) {

      if (!mounted) return;

      if (effect is ShowSnackbarEffect) {
        CustomSnackBar.show(
          context,
          effect.message,
          isError: effect.message.toLowerCase().contains("failed") ||
              effect.message.toLowerCase().contains("error") ||
              effect.message.toLowerCase().contains("already"),
        );
      }

      if (effect is ShowAddedToCartDialogEffect) {
        GlobalDialogs.showAddedToCartDialog(
          selectedItems: effect.items,
        );
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}