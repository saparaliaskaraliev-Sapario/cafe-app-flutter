import 'dish.dart';

/// Строка корзины: блюдо и его количество.
class CartItem {
  const CartItem({required this.dish, required this.quantity});

  final Dish dish;
  final int quantity;

  /// Стоимость строки = цена * количество.
  int get total => dish.price * quantity;

  CartItem copyWith({int? quantity}) =>
      CartItem(dish: dish, quantity: quantity ?? this.quantity);
}
