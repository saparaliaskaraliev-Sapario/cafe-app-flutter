import '../../models/cart_item.dart';
import '../../models/order.dart';

/// Контракт репозитория заказов.
abstract class OrderRepository {
  /// Сохраняет заказ и возвращает его с присвоенным номером.
  Future<Order> placeOrder(List<CartItem> items);

  /// История заказов, новые сверху.
  Future<List<Order>> getOrders();
}
