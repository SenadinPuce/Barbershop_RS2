import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../models/cart.dart';
import '../models/product.dart';

class CartProvider with ChangeNotifier {
  Cart cart = Cart();

  addToCart(Product product, {int quantity = 1}) {
    final existingItem = findInCart(product);

    if (existingItem != null) {
      existingItem.count += quantity;
    } else {
      cart.items.add(CartItem(product, quantity));
    }

    notifyListeners();
  }

  removeFromCart(Product product) {
    cart.items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  CartItem? findInCart(Product product) {
    CartItem? item =
        cart.items.firstWhereOrNull((item) => item.product.id == product.id);
    return item;
  }
}
