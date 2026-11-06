import 'package:flutter/material.dart';

import '../state/cart_controller.dart';

/// Экран корзины: список выбранных блюд и оформление заказа.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key, required this.cart});

  final CartController cart;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _busy = false;

  Future<void> _checkout() async {
    setState(() => _busy = true);
    final order = await widget.cart.checkout();
    if (!mounted) return;
    setState(() => _busy = false);

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Заказ оформлен'),
        content: Text('Заказ №${order.number}\nСумма: ${order.total} ₽'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('ОК'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.pop(context); // вернуться в меню
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.cart,
      builder: (context, _) {
        final items = widget.cart.items;
        return Scaffold(
          appBar: AppBar(title: const Text('Корзина')),
          body: items.isEmpty
              ? const Center(child: Text('Корзина пуста'))
              : ListView(
                  children: [
                    for (final item in items)
                      ListTile(
                        leading: Icon(item.dish.icon),
                        title: Text(item.dish.name),
                        subtitle:
                            Text('${item.dish.price} ₽ × ${item.quantity}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => widget.cart.remove(item.dish),
                            ),
                            Text('${item.total} ₽'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => widget.cart.add(item.dish),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
          bottomNavigationBar: items.isEmpty
              ? null
              : SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: FilledButton(
                      onPressed: _busy ? null : _checkout,
                      child: Text(
                        'Оформить заказ • ${widget.cart.totalPrice} ₽',
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
