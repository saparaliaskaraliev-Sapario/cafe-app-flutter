import 'package:flutter/material.dart';

import '../data/repositories/order_repository.dart';
import '../models/order.dart';

/// История заказов (данные берутся из OrderRepository).
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key, required this.orderRepository});

  final OrderRepository orderRepository;

  String _formatDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}.${two(d.month)}.${d.year} '
        '${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('История заказов')),
      body: FutureBuilder<List<Order>>(
        future: orderRepository.getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final orders = snapshot.data ?? const <Order>[];
          if (orders.isEmpty) {
            return const Center(child: Text('Заказов пока нет'));
          }
          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, i) {
              final order = orders[i];
              final names = order.items
                  .map((item) => '${item.dish.name} × ${item.quantity}')
                  .join(', ');
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text('Заказ №${order.number} • ${order.total} ₽'),
                  subtitle: Text('${_formatDate(order.createdAt)}\n$names'),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
