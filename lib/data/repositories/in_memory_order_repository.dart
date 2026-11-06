import '../../models/cart_item.dart';
import '../../models/order.dart';
import 'order_repository.dart';

/// Хранит заказы в памяти, пока приложение запущено.
/// Для сохранения между запусками можно сделать другую реализацию
/// (например, на shared_preferences или sqflite), не трогая остальной код.
class InMemoryOrderRepository implements OrderRepository {
  final List<Order> _orders = [];
  int _lastNumber = 0;

  @override
  Future<Order> placeOrder(List<CartItem> items) async {
    final order = Order(
      number: ++_lastNumber,
      items: List.unmodifiable(items),
      createdAt: DateTime.now(),
    );
    _orders.add(order);
    return order;
  }

  @override
  Future<List<Order>> getOrders() async => _orders.reversed.toList();
}
