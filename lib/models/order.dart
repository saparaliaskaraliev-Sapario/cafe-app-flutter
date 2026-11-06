import 'cart_item.dart';

/// Оформленный заказ.
class Order {
  const Order({
    required this.number,
    required this.items,
    required this.createdAt,
  });

  final int number;
  final List<CartItem> items;
  final DateTime createdAt;

  int get total => items.fold(0, (sum, item) => sum + item.total);

  int get itemsCount => items.fold(0, (sum, item) => sum + item.quantity);
}
