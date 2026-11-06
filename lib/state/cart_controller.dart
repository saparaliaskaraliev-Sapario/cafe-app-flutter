import 'package:flutter/foundation.dart';

import '../data/repositories/order_repository.dart';
import '../models/cart_item.dart';
import '../models/dish.dart';
import '../models/order.dart';

/// Логика корзины. Наследуется от ChangeNotifier: когда корзина меняется,
/// вызывается notifyListeners(), и экраны, которые на неё подписаны,
/// перерисовываются.
class CartController extends ChangeNotifier {
  CartController(this._orderRepository);

  final OrderRepository _orderRepository;

  // Ключ - id блюда, значение - строка корзины.
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => List.unmodifiable(_items.values);

  bool get isEmpty => _items.isEmpty;

  int get totalCount => _items.values.fold(0, (sum, i) => sum + i.quantity);

  int get totalPrice => _items.values.fold(0, (sum, i) => sum + i.total);

  int quantityOf(Dish dish) => _items[dish.id]?.quantity ?? 0;

  void add(Dish dish) {
    final current = _items[dish.id];
    _items[dish.id] = current == null
        ? CartItem(dish: dish, quantity: 1)
        : current.copyWith(quantity: current.quantity + 1);
    notifyListeners();
  }

  void remove(Dish dish) {
    final current = _items[dish.id];
    if (current == null) return;
    if (current.quantity <= 1) {
      _items.remove(dish.id);
    } else {
      _items[dish.id] = current.copyWith(quantity: current.quantity - 1);
    }
    notifyListeners();
  }

  /// Оформляет заказ через репозиторий и очищает корзину.
  Future<Order> checkout() async {
    if (isEmpty) {
      throw StateError('Корзина пуста');
    }
    final order = await _orderRepository.placeOrder(items);
    _items.clear();
    notifyListeners();
    return order;
  }
}
