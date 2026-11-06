import 'package:flutter/material.dart';

import '../data/repositories/menu_repository.dart';
import '../data/repositories/order_repository.dart';
import '../models/dish.dart';
import '../state/cart_controller.dart';
import '../widgets/dish_tile.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

/// Главный экран: меню по категориям и кнопка корзины.
class MenuScreen extends StatefulWidget {
  const MenuScreen({
    super.key,
    required this.menuRepository,
    required this.orderRepository,
    required this.cart,
  });

  final MenuRepository menuRepository;
  final OrderRepository orderRepository;
  final CartController cart;

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Dish>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _menuFuture = widget.menuRepository.getMenu();
  }

  void _reload() {
    setState(() {
      _menuFuture = widget.menuRepository.getMenu();
    });
  }

  void _openCart() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CartScreen(cart: widget.cart)),
    );
  }

  void _openOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OrdersScreen(orderRepository: widget.orderRepository),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Меню'),
        actions: [
          IconButton(
            tooltip: 'История заказов',
            icon: const Icon(Icons.receipt_long),
            onPressed: _openOrders,
          ),
        ],
      ),
      body: FutureBuilder<List<Dish>>(
        future: _menuFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Не удалось загрузить меню'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: _reload,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }
          return _buildMenu(snapshot.data ?? const []);
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: widget.cart,
        builder: (context, _) {
          if (widget.cart.isEmpty) return const SizedBox.shrink();
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: FilledButton.icon(
                onPressed: _openCart,
                icon: const Icon(Icons.shopping_cart),
                label: Text(
                  'Корзина: ${widget.cart.totalCount} шт. • '
                  '${widget.cart.totalPrice} ₽',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu(List<Dish> dishes) {
    // Группируем блюда по категориям, порядок сохраняется.
    final byCategory = <String, List<Dish>>{};
    for (final dish in dishes) {
      byCategory.putIfAbsent(dish.category, () => []).add(dish);
    }

    return ListView(
      children: [
        for (final entry in byCategory.entries) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              entry.key,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final dish in entry.value)
            // Перерисовываем только строку, когда меняется корзина.
            ListenableBuilder(
              listenable: widget.cart,
              builder: (context, _) => DishTile(
                dish: dish,
                quantity: widget.cart.quantityOf(dish),
                onAdd: () => widget.cart.add(dish),
                onRemove: () => widget.cart.remove(dish),
              ),
            ),
        ],
      ],
    );
  }
}
